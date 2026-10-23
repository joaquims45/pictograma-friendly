import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pictograma_friendly/core/db/app_database.dart';
import 'package:pictograma_friendly/core/db/queries.dart';
import 'package:pictograma_friendly/core/db/routine_queries.dart';
import 'package:pictograma_friendly/core/db/seed.dart';
import 'package:pictograma_friendly/features/routines/domain/routine_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late int profileId;
  late List<Pictogram> pics;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedIfEmpty(db);
    profileId = (await db.allProfiles()).first.id;
    pics = (await db.allPictograms()).take(4).toList();
  });
  tearDown(() => db.close());

  Future<(Routine, List<int>)> build() async {
    final r = await db.createRoutine(profileId, 'Mañana');
    for (final p in pics) {
      await db.addRoutineStep(r.id, p.id);
    }
    final ids = (await db.routineStepEntries(r.id))
        .map((e) => e.step.id)
        .toList();
    return (r, ids);
  }

  test('crea rutina con pasos en orden', () async {
    final (r, _) = await build();
    final steps = await db.routineStepEntries(r.id);
    expect(steps.map((e) => e.pictogram.id), pics.map((p) => p.id));
    expect(steps.map((e) => e.step.position), [0, 1, 2, 3]);
    expect((await db.routinesFor(profileId)).single.name, 'Mañana');
  });

  test('primero / después avanzan al marcar listo', () async {
    final (r, ids) = await build();
    var progress = RoutineProgress(await db.routineStepEntries(r.id));
    expect(progress.current!.step.id, ids[0]);
    expect(progress.next!.step.id, ids[1]);
    expect(progress.finished, isFalse);

    await db.setStepDone(ids[0], true);
    progress = RoutineProgress(await db.routineStepEntries(r.id));
    expect(progress.current!.step.id, ids[1]);
    expect(progress.next!.step.id, ids[2]);
    expect(progress.doneCount, 1);

    for (final id in ids.skip(1)) {
      await db.setStepDone(id, true);
    }
    progress = RoutineProgress(await db.routineStepEntries(r.id));
    expect(progress.finished, isTrue);
    expect(progress.current, isNull);
    expect(progress.next, isNull);
  });

  test('el último paso no tiene "después"', () async {
    final (r, ids) = await build();
    for (final id in ids.take(3)) {
      await db.setStepDone(id, true);
    }
    final progress = RoutineProgress(await db.routineStepEntries(r.id));
    expect(progress.current!.step.id, ids[3]);
    expect(progress.next, isNull);
  });

  test('reiniciar desmarca todo; reordenar y quitar pasos', () async {
    final (r, ids) = await build();
    await db.setStepDone(ids[0], true);
    await db.resetRoutine(r.id);
    expect(
      (await db.routineStepEntries(r.id)).every((e) => !e.step.done),
      isTrue,
    );

    await db.reorderRoutineSteps(ids.reversed.toList());
    expect(
      (await db.routineStepEntries(r.id)).map((e) => e.step.id),
      ids.reversed,
    );

    await db.removeRoutineStep(ids[0]);
    expect((await db.routineStepEntries(r.id)).length, 3);
  });

  test(
    'un pictograma se puede repetir y borrar la rutina limpia los pasos',
    () async {
      final r = await db.createRoutine(profileId, 'Baño');
      await db.addRoutineStep(r.id, pics[0].id);
      await db.addRoutineStep(r.id, pics[0].id);
      expect((await db.routineStepEntries(r.id)).length, 2);

      await db.deleteRoutine(r.id);
      expect(await db.routinesFor(profileId), isEmpty);
      expect(await db.select(db.routineSteps).get(), isEmpty);
    },
  );
}
