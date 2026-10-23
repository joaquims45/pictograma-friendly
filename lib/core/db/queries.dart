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

  /// Categorías visibles de un perfil, en su orden fijo.
  Future<List<Category>> categoriesForProfile(int profileId) async {
    final query =
        select(profileCategories).join([
            innerJoin(
              categories,
              categories.id.equalsExp(profileCategories.categoryId),
            ),
          ])
          ..where(
            profileCategories.profileId.equals(profileId) &
                profileCategories.hidden.equals(false),
          )
          ..orderBy([OrderingTerm.asc(profileCategories.position)]);
    final rows = await query.get();
    return rows.map((r) => r.readTable(categories)).toList();
  }
}
