import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:pictograma_friendly/core/backup/backup_service.dart';
import 'package:pictograma_friendly/core/db/admin_queries.dart';
import 'package:pictograma_friendly/core/db/app_database.dart';
import 'package:pictograma_friendly/core/db/queries.dart';
import 'package:pictograma_friendly/core/db/routine_queries.dart';
import 'package:pictograma_friendly/core/db/seed.dart';
import 'package:pictograma_friendly/core/db/usage_queries.dart';
import 'package:pictograma_friendly/core/media/media_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late Directory rootA;
  late Directory rootB;
  late AppDatabase dbA;
  late AppDatabase dbB;
  late MediaStore mediaA;
  late MediaStore mediaB;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('backup_test');
    rootA = Directory(p.join(tmp.path, 'a'))..createSync();
    rootB = Directory(p.join(tmp.path, 'b'))..createSync();
    dbA = AppDatabase(NativeDatabase.memory());
    dbB = AppDatabase(NativeDatabase.memory());
    mediaA = MediaStore(root: rootA);
    mediaB = MediaStore(root: rootB);
  });

  tearDown(() async {
    await dbA.close();
    await dbB.close();
    tmp.deleteSync(recursive: true);
  });

  /// Arma un teléfono "A" con datos propios: foto, audio, categoría, rutina, uso.
  Future<void> populateA() async {
    await seedIfEmpty(dbA);
    final simple = (await dbA.allProfiles()).first;
    final dense = (await dbA.allProfiles()).last;
    final cat = (await dbA.select(dbA.categories).get()).first;

    final photo = File(p.join(rootA.path, 'photos', '111.jpg'))
      ..createSync(recursive: true)
      ..writeAsBytesSync([1, 2, 3, 4]);
    final audio = File(p.join(rootA.path, 'audio', '222.m4a'))
      ..createSync(recursive: true)
      ..writeAsBytesSync([9, 8, 7]);

    final upa = await dbA.createCustomPictogram(
      label: 'upa',
      categoryId: cat.id,
      photoPath: photo.path,
      audioPath: audio.path,
    );
    await dbA.addToBoard(simple.id, null, upa.id);
    await dbA.updateProfileSettings(simple.id, gridSize: 4);
    await dbA.createCategory(
      profileId: dense.id,
      name: 'Escuela',
      colorHex: '#CFE0EC',
    );
    final routine = await dbA.createRoutine(simple.id, 'Mañana');
    await dbA.addRoutineStep(routine.id, upa.id);
    await dbA.setUsageLogEnabled(true);
    await dbA.logUsage(simple.id, upa.id, 'board');
  }

  test('crear y restaurar en otro teléfono conserva datos y medios', () async {
    await populateA();
    final bytes = await BackupService(dbA, mediaA).createBackup();

    // El teléfono B ya tenía otros datos que se reemplazan.
    await seedIfEmpty(dbB);
    await dbB.createRoutine((await dbB.allProfiles()).first.id, 'Vieja');
    final stale = File(p.join(rootB.path, 'photos', 'vieja.jpg'))
      ..createSync(recursive: true)
      ..writeAsBytesSync([5]);

    await BackupService(dbB, mediaB).restore(bytes);

    final profiles = await dbB.allProfiles();
    expect(profiles.map((e) => e.name), ['Perfil 1', 'Perfil 2']);
    expect(profiles.first.gridSize, 4);

    final board = await dbB.boardEntries(profiles.first.id, null);
    final upa = board.last.pictogram;
    expect(upa.labelEs, 'upa');
    expect(upa.isCustom, isTrue);
    expect(upa.photoPath, p.join(rootB.path, 'photos', '111.jpg'));
    expect(File(upa.photoPath!).readAsBytesSync(), [1, 2, 3, 4]);
    expect(File(upa.audioPath!).readAsBytesSync(), [9, 8, 7]);

    final kidCats = await dbB.profileCategoryLinks(profiles.last.id);
    expect(kidCats.last.category.nameEs, 'Escuela');

    final routines = await dbB.routinesFor(profiles.first.id);
    expect(routines.map((r) => r.name), ['Mañana']);
    expect((await dbB.routineStepEntries(routines.single.id)).length, 1);

    expect(await dbB.isUsageLogEnabled(), isTrue);
    expect(await dbB.usageEventCount(), 1);

    // Lo que no estaba en la copia desaparece, también del disco.
    expect(stale.existsSync(), isFalse);
  });

  test('un archivo que no es una copia no toca nada', () async {
    await seedIfEmpty(dbB);
    final service = BackupService(dbB, mediaB);

    await expectLater(
      service.restore(Uint8List.fromList([1, 2, 3])),
      throwsA(isA<BackupException>()),
    );

    final other = Archive()
      ..addFile(ArchiveFile.bytes('hola.txt', utf8.encode('hola')));
    await expectLater(
      service.restore(ZipEncoder().encodeBytes(other)),
      throwsA(isA<BackupException>()),
    );

    expect((await dbB.allProfiles()).length, 2);
  });

  test('rechaza copias de una versión más nueva', () async {
    await seedIfEmpty(dbB);
    final manifest = {
      'app': BackupService.appId,
      'formatVersion': BackupService.formatVersion + 1,
      'tables': {'profiles': [], 'categories': [], 'pictograms': []},
    };
    final archive = Archive()
      ..addFile(
        ArchiveFile.bytes('backup.json', utf8.encode(jsonEncode(manifest))),
      );

    await expectLater(
      BackupService(dbB, mediaB).restore(ZipEncoder().encodeBytes(archive)),
      throwsA(isA<BackupException>()),
    );
    expect((await dbB.allProfiles()).length, 2);
  });

  test('una copia sin un archivo de medios restaura sin esa foto', () async {
    await populateA();
    final bytes = await BackupService(dbA, mediaA).createBackup();

    final archive = ZipDecoder().decodeBytes(bytes);
    final trimmed = Archive();
    for (final f in archive) {
      if (f.name != 'media/photos/111.jpg') {
        trimmed.addFile(ArchiveFile.bytes(f.name, f.content));
      }
    }
    await BackupService(dbB, mediaB).restore(ZipEncoder().encodeBytes(trimmed));

    final simple = (await dbB.allProfiles()).first;
    final upa = (await dbB.boardEntries(simple.id, null)).last.pictogram;
    expect(upa.photoPath, isNull);
    expect(upa.audioPath, isNotNull);
  });

  test('el nombre del archivo lleva la fecha', () {
    expect(
      BackupService.fileName(DateTime(2026, 3, 7)),
      'pictogramas_20260307.zip',
    );
  });

  test('registro de uso: apagado por defecto, resumen y CSV', () async {
    await seedIfEmpty(dbA);
    expect(await dbA.isUsageLogEnabled(), isFalse);

    final profile = (await dbA.allProfiles()).first;
    final pics = (await dbA.select(dbA.pictograms).get()).take(2).toList();
    await dbA.logUsage(profile.id, pics[0].id, 'board');
    await dbA.logUsage(profile.id, pics[0].id, 'board');
    await dbA.logUsage(profile.id, pics[1].id, 'routine');

    final summary = await dbA.usageSummary(
      since: DateTime.now().subtract(const Duration(days: 7)),
    );
    expect(summary.total, 3);
    expect(summary.top.first, (label: pics[0].labelEs, count: 2));

    final csv = usageToCsv(await dbA.usageExportRows());
    final lines = const LineSplitter().convert(csv);
    expect(lines.first, 'fecha_hora,perfil,pictograma,origen');
    expect(lines.length, 4);
    expect(lines[1], contains('"Perfil 1"'));

    await dbA.clearUsageLog();
    expect(await dbA.usageEventCount(), 0);
  });

  test('el CSV escapa comillas', () {
    final csv = usageToCsv([
      (
        at: DateTime(2026, 1, 1),
        profile: 'A "x"',
        pictogram: 'b,c',
        source: 'board',
      ),
    ]);
    expect(csv, contains('"A ""x"""'));
    expect(csv, contains('"b,c"'));
  });
}
