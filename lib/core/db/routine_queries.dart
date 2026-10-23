import 'package:drift/drift.dart';

import 'app_database.dart';

typedef RoutineStepEntry = ({RoutineStep step, Pictogram pictogram});

extension RoutineQueries on AppDatabase {
  Future<List<Routine>> routinesFor(int profileId) =>
      (select(routines)
            ..where((r) => r.profileId.equals(profileId))
            ..orderBy([
              (r) => OrderingTerm.asc(r.position),
              (r) => OrderingTerm.asc(r.id),
            ]))
          .get();

  Future<Routine> createRoutine(int profileId, String name) async {
    final maxPos = routines.position.max();
    final row =
        await (selectOnly(routines)
              ..addColumns([maxPos])
              ..where(routines.profileId.equals(profileId)))
            .getSingle();
    final id = await into(routines).insert(
      RoutinesCompanion.insert(
        profileId: profileId,
        name: name,
        position: Value((row.read(maxPos) ?? -1) + 1),
      ),
    );
    return (select(routines)..where((r) => r.id.equals(id))).getSingle();
  }

  Future<void> renameRoutine(int routineId, String name) =>
      (update(routines)..where((r) => r.id.equals(routineId))).write(
        RoutinesCompanion(name: Value(name)),
      );

  Future<void> deleteRoutine(int routineId) => transaction(() async {
    await (delete(
      routineSteps,
    )..where((s) => s.routineId.equals(routineId))).go();
    await (delete(routines)..where((r) => r.id.equals(routineId))).go();
  });

  /// Pasos de una rutina en su orden fijo.
  Future<List<RoutineStepEntry>> routineStepEntries(int routineId) async {
    final query =
        select(routineSteps).join([
            innerJoin(
              pictograms,
              pictograms.id.equalsExp(routineSteps.pictogramId),
            ),
          ])
          ..where(routineSteps.routineId.equals(routineId))
          ..orderBy([OrderingTerm.asc(routineSteps.position)]);
    final rows = await query.get();
    return rows
        .map(
          (r) => (
            step: r.readTable(routineSteps),
            pictogram: r.readTable(pictograms),
          ),
        )
        .toList();
  }

  Future<void> addRoutineStep(int routineId, int pictogramId) async {
    final maxPos = routineSteps.position.max();
    final row =
        await (selectOnly(routineSteps)
              ..addColumns([maxPos])
              ..where(routineSteps.routineId.equals(routineId)))
            .getSingle();
    await into(routineSteps).insert(
      RoutineStepsCompanion.insert(
        routineId: routineId,
        pictogramId: pictogramId,
        position: (row.read(maxPos) ?? -1) + 1,
      ),
    );
  }

  Future<void> removeRoutineStep(int stepId) =>
      (delete(routineSteps)..where((s) => s.id.equals(stepId))).go();

  Future<void> reorderRoutineSteps(List<int> stepIdsInOrder) =>
      transaction(() async {
        for (var i = 0; i < stepIdsInOrder.length; i++) {
          await (update(routineSteps)
                ..where((s) => s.id.equals(stepIdsInOrder[i])))
              .write(RoutineStepsCompanion(position: Value(i)));
        }
      });

  Future<void> setStepDone(int stepId, bool done) =>
      (update(routineSteps)..where((s) => s.id.equals(stepId))).write(
        RoutineStepsCompanion(done: Value(done)),
      );

  /// Vuelve a empezar: desmarca todos los pasos.
  Future<void> resetRoutine(int routineId) =>
      (update(routineSteps)..where((s) => s.routineId.equals(routineId))).write(
        const RoutineStepsCompanion(done: Value(false)),
      );

  /// Todos los pictogramas, para armar pasos (se pueden repetir).
  Future<List<Pictogram>> allPictograms() =>
      (select(pictograms)..orderBy([(p) => OrderingTerm.asc(p.labelEs)])).get();
}
