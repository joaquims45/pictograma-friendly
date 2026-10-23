import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pictograma_friendly/core/db/admin_queries.dart';
import 'package:pictograma_friendly/core/db/app_database.dart';
import 'package:pictograma_friendly/core/db/queries.dart';
import 'package:pictograma_friendly/core/db/seed.dart';
import 'package:pictograma_friendly/core/security/pin_service.dart';

class _MemoryStore implements KeyValueStore {
  final map = <String, String>{};
  @override
  Future<String?> read(String key) async => map[key];
  @override
  Future<void> write(String key, String value) async => map[key] = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('PIN', () {
    test('guarda hash con sal y verifica', () async {
      final store = _MemoryStore();
      final pin = PinService(store);
      expect(await pin.hasPin(), isFalse);
      await pin.setPin('1234');
      expect(await pin.hasPin(), isTrue);
      expect(await pin.verify('1234'), isTrue);
      expect(await pin.verify('4321'), isFalse);
      expect(store.map.values.any((v) => v.contains('1234')), isFalse);
    });

    test('rechaza formatos inválidos', () async {
      final pin = PinService(_MemoryStore());
      expect(() => pin.setPin('12'), throwsArgumentError);
      expect(() => pin.setPin('abcd'), throwsArgumentError);
    });
  });

  group('modo adulto', () {
    test('reordenar y ocultar respetan la posición elegida', () async {
      await seedIfEmpty(db);
      final twins = (await db.allProfiles()).first;
      final entries = await db.boardEntries(twins.id, null);
      final ids = entries.map((e) => e.item.id).toList();

      await db.reorderItems(ids.reversed.toList());
      final reordered = await db.boardEntries(twins.id, null);
      expect(reordered.map((e) => e.item.id), ids.reversed);

      await db.setItemHidden(ids.first, true);
      final visible = await db.boardPictograms(twins.id, null);
      expect(visible.length, ids.length - 1);
    });

    test('crea pictograma propio y lo agrega al final del tablero', () async {
      await seedIfEmpty(db);
      final twins = (await db.allProfiles()).first;
      final cat = (await db.select(db.categories).get()).first;
      final before = await db.boardEntries(twins.id, null);

      final pic = await db.createCustomPictogram(
        label: 'upa',
        categoryId: cat.id,
        photoPath: '/tmp/foto.jpg',
      );
      await db.addToBoard(twins.id, null, pic.id);

      final after = await db.boardEntries(twins.id, null);
      expect(after.length, before.length + 1);
      expect(after.last.pictogram.labelEs, 'upa');
      expect(after.last.pictogram.isCustom, isTrue);
      expect(after.last.item.position, before.length);
    });

    test('categorías propias: crear, ocultar y reordenar', () async {
      await seedIfEmpty(db);
      final kid = (await db.allProfiles()).last;
      final cat = await db.createCategory(
        profileId: kid.id,
        name: 'Escuela',
        colorHex: '#CFE0EC',
      );

      var links = await db.profileCategoryLinks(kid.id);
      expect(links.last.category.id, cat.id);
      expect(links.last.category.isCustom, isTrue);

      await db.reorderCategories(
        links.map((l) => l.link.id).toList().reversed.toList(),
      );
      links = await db.profileCategoryLinks(kid.id);
      expect(links.first.category.id, cat.id);

      await db.setCategoryHidden(links.first.link.id, true);
      final visible = await db.categoriesForProfile(kid.id);
      expect(visible.any((c) => c.id == cat.id), isFalse);
    });

    test('ajustes de perfil', () async {
      await seedIfEmpty(db);
      final twins = (await db.allProfiles()).first;
      await db.updateProfileSettings(twins.id, gridSize: 4);
      expect((await db.allProfiles()).first.gridSize, 4);
      expect((await db.allProfiles()).first.phraseBarEnabled, isFalse);
    });

    test('updatePictogram guarda foto y audio', () async {
      await seedIfEmpty(db);
      final p = (await db.select(db.pictograms).get()).first;
      await db.updatePictogram(p.id, audioPath: const Value('/a.m4a'));
      final u = await (db.select(
        db.pictograms,
      )..where((t) => t.id.equals(p.id))).getSingle();
      expect(u.audioPath, '/a.m4a');
    });
  });
}
