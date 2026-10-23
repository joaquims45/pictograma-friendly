import 'package:drift/drift.dart';

import 'app_database.dart';

typedef BoardEntry = ({BoardItem item, Pictogram pictogram});
typedef CategoryLink = ({ProfileCategory link, Category category});

/// Operaciones del modo adulto. Nada se reordena solo: solo lo que el adulto decide.
extension AdminQueries on AppDatabase {
  Future<void> renameProfile(int profileId, String name) =>
      (update(profiles)..where((p) => p.id.equals(profileId))).write(
        ProfilesCompanion(name: Value(name)),
      );

  Future<void> updateProfileSettings(
    int profileId, {
    int? gridSize,
    bool? phraseBarEnabled,
  }) => (update(profiles)..where((p) => p.id.equals(profileId))).write(
    ProfilesCompanion(
      gridSize: gridSize == null ? const Value.absent() : Value(gridSize),
      phraseBarEnabled: phraseBarEnabled == null
          ? const Value.absent()
          : Value(phraseBarEnabled),
    ),
  );

  Expression<bool> _inBoard(int profileId, int? categoryId) =>
      boardItems.profileId.equals(profileId) &
      (categoryId == null
          ? boardItems.categoryId.isNull()
          : boardItems.categoryId.equals(categoryId));

  /// Todos los ítems de un tablero (incluye ocultos), en orden.
  Future<List<BoardEntry>> boardEntries(int profileId, int? categoryId) async {
    final query =
        select(boardItems).join([
            innerJoin(
              pictograms,
              pictograms.id.equalsExp(boardItems.pictogramId),
            ),
          ])
          ..where(_inBoard(profileId, categoryId))
          ..orderBy([OrderingTerm.asc(boardItems.position)]);
    final rows = await query.get();
    return rows
        .map(
          (r) => (
            item: r.readTable(boardItems),
            pictogram: r.readTable(pictograms),
          ),
        )
        .toList();
  }

  Future<void> setItemHidden(int itemId, bool hidden) =>
      (update(boardItems)..where((b) => b.id.equals(itemId))).write(
        BoardItemsCompanion(hidden: Value(hidden)),
      );

  /// Guarda el orden elegido. Dos pasadas para no chocar con la clave única.
  Future<void> reorderItems(List<int> itemIdsInOrder) => transaction(() async {
    for (var i = 0; i < itemIdsInOrder.length; i++) {
      await (update(boardItems)..where((b) => b.id.equals(itemIdsInOrder[i])))
          .write(BoardItemsCompanion(position: Value(-(i + 1))));
    }
    for (var i = 0; i < itemIdsInOrder.length; i++) {
      await (update(boardItems)..where((b) => b.id.equals(itemIdsInOrder[i])))
          .write(BoardItemsCompanion(position: Value(i)));
    }
  });

  /// Agrega un pictograma existente al final de un tablero.
  Future<void> addToBoard(
    int profileId,
    int? categoryId,
    int pictogramId,
  ) async {
    final maxPos = boardItems.position.max();
    final row =
        await (selectOnly(boardItems)
              ..addColumns([maxPos])
              ..where(_inBoard(profileId, categoryId)))
            .getSingle();
    await into(boardItems).insert(
      BoardItemsCompanion.insert(
        profileId: profileId,
        categoryId: Value(categoryId),
        pictogramId: pictogramId,
        position: (row.read(maxPos) ?? -1) + 1,
      ),
    );
  }

  Future<void> removeFromBoard(int itemId) =>
      (delete(boardItems)..where((b) => b.id.equals(itemId))).go();

  /// Pictogramas que todavía no están en ese tablero (para agregarlos).
  Future<List<Pictogram>> pictogramsNotOnBoard(
    int profileId,
    int? categoryId,
  ) async {
    final used =
        await (selectOnly(boardItems)
              ..addColumns([boardItems.pictogramId])
              ..where(_inBoard(profileId, categoryId)))
            .map((r) => r.read(boardItems.pictogramId)!)
            .get();
    return (select(pictograms)
          ..where((p) => p.id.isNotIn(used))
          ..orderBy([(p) => OrderingTerm.asc(p.labelEs)]))
        .get();
  }

  Future<Pictogram> createCustomPictogram({
    required String label,
    required int categoryId,
    String? photoPath,
    String? audioPath,
  }) async {
    final cat = await (select(
      categories,
    )..where((c) => c.id.equals(categoryId))).getSingle();
    final id = await into(pictograms).insert(
      PictogramsCompanion.insert(
        labelEs: label,
        categoryId: categoryId,
        photoPath: Value(photoPath),
        audioPath: Value(audioPath),
        colorHex: Value(cat.colorHex),
        isCustom: const Value(true),
      ),
    );
    return (select(pictograms)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<void> updatePictogram(
    int id, {
    String? label,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
  }) => (update(pictograms)..where((p) => p.id.equals(id))).write(
    PictogramsCompanion(
      labelEs: label == null ? const Value.absent() : Value(label),
      photoPath: photoPath,
      audioPath: audioPath,
    ),
  );

  /// Categorías de un perfil incluyendo ocultas, en orden.
  Future<List<CategoryLink>> profileCategoryLinks(int profileId) async {
    final query =
        select(profileCategories).join([
            innerJoin(
              categories,
              categories.id.equalsExp(profileCategories.categoryId),
            ),
          ])
          ..where(profileCategories.profileId.equals(profileId))
          ..orderBy([OrderingTerm.asc(profileCategories.position)]);
    final rows = await query.get();
    return rows
        .map(
          (r) => (
            link: r.readTable(profileCategories),
            category: r.readTable(categories),
          ),
        )
        .toList();
  }

  Future<void> setCategoryHidden(int linkId, bool hidden) =>
      (update(profileCategories)..where((l) => l.id.equals(linkId))).write(
        ProfileCategoriesCompanion(hidden: Value(hidden)),
      );

  Future<void> reorderCategories(List<int> linkIdsInOrder) =>
      transaction(() async {
        for (var i = 0; i < linkIdsInOrder.length; i++) {
          await (update(profileCategories)
                ..where((l) => l.id.equals(linkIdsInOrder[i])))
              .write(ProfileCategoriesCompanion(position: Value(-(i + 1))));
        }
        for (var i = 0; i < linkIdsInOrder.length; i++) {
          await (update(profileCategories)
                ..where((l) => l.id.equals(linkIdsInOrder[i])))
              .write(ProfileCategoriesCompanion(position: Value(i)));
        }
      });

  /// Crea una categoría propia y la agrega al final de un perfil.
  Future<Category> createCategory({
    required int profileId,
    required String name,
    required String colorHex,
  }) => transaction(() async {
    final id = await into(categories).insert(
      CategoriesCompanion.insert(
        key: 'custom_${DateTime.now().microsecondsSinceEpoch}',
        nameEs: name,
        colorHex: colorHex,
        isCustom: const Value(true),
      ),
    );
    final maxPos = profileCategories.position.max();
    final row =
        await (selectOnly(profileCategories)
              ..addColumns([maxPos])
              ..where(profileCategories.profileId.equals(profileId)))
            .getSingle();
    await into(profileCategories).insert(
      ProfileCategoriesCompanion.insert(
        profileId: profileId,
        categoryId: id,
        position: (row.read(maxPos) ?? -1) + 1,
      ),
    );
    return (select(categories)..where((c) => c.id.equals(id))).getSingle();
  });
}
