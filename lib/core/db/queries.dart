import 'package:drift/drift.dart';

import 'app_database.dart';

extension BoardQueries on AppDatabase {
  Future<List<Profile>> allProfiles() =>
      (select(profiles)..orderBy([(p) => OrderingTerm.asc(p.id)])).get();

  /// Pictogramas visibles de un tablero, en el orden fijo elegido por el adulto.
  Future<List<Pictogram>> boardPictograms(
    int profileId,
    int? categoryId,
  ) async {
    final query =
        select(boardItems).join([
            innerJoin(
              pictograms,
              pictograms.id.equalsExp(boardItems.pictogramId),
            ),
          ])
          ..where(
            boardItems.profileId.equals(profileId) &
                boardItems.hidden.equals(false) &
                (categoryId == null
                    ? boardItems.categoryId.isNull()
                    : boardItems.categoryId.equals(categoryId)),
          )
          ..orderBy([OrderingTerm.asc(boardItems.position)]);
    final rows = await query.get();
    return rows.map((r) => r.readTable(pictograms)).toList();
  }

  /// Categorías que tiene un perfil, en orden fijo por id.
  Future<List<Category>> profileCategories(int profileId) async {
    final ids =
        await (select(boardItems)..where(
              (b) => b.profileId.equals(profileId) & b.categoryId.isNotNull(),
            ))
            .map((b) => b.categoryId!)
            .get();
    if (ids.isEmpty) return [];
    return (select(categories)
          ..where((c) => c.id.isIn(ids.toSet()))
          ..orderBy([(c) => OrderingTerm.asc(c.id)]))
        .get();
  }
}
