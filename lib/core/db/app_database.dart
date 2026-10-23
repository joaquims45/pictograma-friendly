import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Profiles,
    Categories,
    Pictograms,
    BoardItems,
    ProfileCategories,
    Routines,
    RoutineSteps,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'pictogramas'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.createTable(routines);
        await m.createTable(routineSteps);
      }
      if (from < 2) {
        await m.createTable(profileCategories);
        // Una fila por categoría usada en cada perfil, en el orden previo (por id).
        await customStatement(
          'INSERT INTO profile_categories (profile_id, category_id, position, hidden) '
          'SELECT profile_id, category_id, '
          'ROW_NUMBER() OVER (PARTITION BY profile_id ORDER BY category_id) - 1, 0 '
          'FROM (SELECT DISTINCT profile_id, category_id FROM board_items '
          'WHERE category_id IS NOT NULL)',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
