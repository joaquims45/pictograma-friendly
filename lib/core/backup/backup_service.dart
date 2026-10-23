import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../media/media_store.dart';

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Copia de seguridad en un único `.zip`: `backup.json` con todos los datos y
/// `media/` con las fotos y audios propios. El PIN no se incluye: queda en el
/// teléfono (si se restaura en otro, se crea uno nuevo).
class BackupService {
  BackupService(this._db, this._media);

  final AppDatabase _db;
  final MediaStore _media;

  static const appId = 'pictograma_friendly';
  static const formatVersion = 1;
  static const _manifest = 'backup.json';

  static String fileName([DateTime? now]) {
    final t = now ?? DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'pictogramas_${t.year}${two(t.month)}${two(t.day)}.zip';
  }

  Future<Uint8List> createBackup() async {
    final archive = Archive();
    final added = <String>{};

    Future<String?> addMedia(String? fullPath) async {
      final rel = await _media.relativePath(fullPath);
      if (rel == null) return null;
      if (added.add(rel)) {
        final bytes = await File(fullPath!).readAsBytes();
        archive.addFile(ArchiveFile.bytes('media/$rel', bytes));
      }
      return rel;
    }

    final pictograms = <Map<String, dynamic>>[];
    for (final p in await _db.select(_db.pictograms).get()) {
      final json = p.toJson();
      json['photoPath'] = await addMedia(p.photoPath);
      json['audioPath'] = await addMedia(p.audioPath);
      pictograms.add(json);
    }

    final manifest = {
      'app': appId,
      'formatVersion': formatVersion,
      'schemaVersion': _db.schemaVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'tables': {
        'profiles': _json(await _db.select(_db.profiles).get()),
        'categories': _json(await _db.select(_db.categories).get()),
        'pictograms': pictograms,
        'boardItems': _json(await _db.select(_db.boardItems).get()),
        'profileCategories': _json(
          await _db.select(_db.profileCategories).get(),
        ),
        'routines': _json(await _db.select(_db.routines).get()),
        'routineSteps': _json(await _db.select(_db.routineSteps).get()),
        'appSettings': _json(await _db.select(_db.appSettings).get()),
        'usageLog': _json(await _db.select(_db.usageLog).get()),
      },
    };
    archive.addFile(
      ArchiveFile.bytes(_manifest, utf8.encode(jsonEncode(manifest))),
    );
    return ZipEncoder().encodeBytes(archive);
  }

  /// Reemplaza TODOS los datos por los de la copia. Valida antes de tocar nada.
  Future<void> restore(Uint8List zipBytes) async {
    final data = _parse(zipBytes);
    final tables = data.tables;

    // 1) Archivos de medios (antes de la base: si falla, no se pierde nada).
    final pictograms = <Map<String, dynamic>>[];
    final keep = <String>{};
    for (final raw in tables['pictograms']!) {
      final json = Map<String, dynamic>.from(raw);
      for (final key in const ['photoPath', 'audioPath']) {
        final rel = json[key] as String?;
        final bytes = rel == null ? null : data.media[rel];
        if (rel == null || bytes == null) {
          json[key] = null;
          continue;
        }
        await _media.writeRelative(rel, bytes);
        json[key] = await _media.fullPath(rel);
        keep.add(json[key] as String);
      }
      pictograms.add(json);
    }

    // 2) Base de datos, todo o nada.
    await _db.transaction(() async {
      await _db.delete(_db.usageLog).go();
      await _db.delete(_db.routineSteps).go();
      await _db.delete(_db.routines).go();
      await _db.delete(_db.boardItems).go();
      await _db.delete(_db.profileCategories).go();
      await _db.delete(_db.pictograms).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.profiles).go();
      await _db.delete(_db.appSettings).go();

      Future<void> fill<T extends Table, D>(
        TableInfo<T, D> table,
        List<Map<String, dynamic>> rows,
        D Function(Map<String, dynamic>) fromJson,
      ) async {
        for (final row in rows) {
          await _db.into(table).insert(fromJson(row) as Insertable<D>);
        }
      }

      List<Map<String, dynamic>> rows(String name) => (tables[name] ?? const [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      await fill(_db.profiles, rows('profiles'), Profile.fromJson);
      await fill(_db.categories, rows('categories'), Category.fromJson);
      await fill(_db.pictograms, pictograms, Pictogram.fromJson);
      await fill(_db.boardItems, rows('boardItems'), BoardItem.fromJson);
      await fill(
        _db.profileCategories,
        rows('profileCategories'),
        ProfileCategory.fromJson,
      );
      await fill(_db.routines, rows('routines'), Routine.fromJson);
      await fill(_db.routineSteps, rows('routineSteps'), RoutineStep.fromJson);
      await fill(_db.appSettings, rows('appSettings'), AppSetting.fromJson);
      await fill(_db.usageLog, rows('usageLog'), UsageEvent.fromJson);
    });

    // 3) Limpieza de archivos que quedaron sin uso.
    await _media.deleteUnreferenced(keep);
  }

  _ParsedBackup _parse(Uint8List zipBytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (_) {
      throw const BackupException('El archivo no es una copia válida.');
    }
    final manifestFile = archive.findFile(_manifest);
    if (manifestFile == null) {
      throw const BackupException('El archivo no es una copia de esta app.');
    }
    final Map<String, dynamic> json;
    try {
      json =
          jsonDecode(utf8.decode(manifestFile.content)) as Map<String, dynamic>;
    } catch (_) {
      throw const BackupException('La copia está dañada.');
    }
    if (json['app'] != appId) {
      throw const BackupException('El archivo no es una copia de esta app.');
    }
    final version = json['formatVersion'];
    if (version is! int || version > formatVersion) {
      throw const BackupException(
        'La copia es de una versión más nueva de la app. Actualizá la app.',
      );
    }
    final rawTables = json['tables'];
    if (rawTables is! Map) throw const BackupException('La copia está dañada.');
    final tables = <String, List<Map<String, dynamic>>>{};
    for (final entry in rawTables.entries) {
      tables[entry.key as String] = (entry.value as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    for (final required in const ['profiles', 'categories', 'pictograms']) {
      if (!tables.containsKey(required)) {
        throw const BackupException('La copia está dañada.');
      }
    }
    final media = <String, Uint8List>{};
    for (final f in archive) {
      if (f.isFile && f.name.startsWith('media/')) {
        media[f.name.substring('media/'.length)] = f.content;
      }
    }
    return _ParsedBackup(tables, media);
  }

  List<Map<String, dynamic>> _json(List<DataClass> rows) =>
      rows.map((r) => r.toJson()).toList();
}

class _ParsedBackup {
  _ParsedBackup(this.tables, this.media);
  final Map<String, List<Map<String, dynamic>>> tables;
  final Map<String, Uint8List> media;
}
