import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/routine_queries.dart';
import '../../../core/providers.dart';

/// autoDispose: siempre muestran lo último guardado.
final routinesProvider = FutureProvider.autoDispose.family<List<Routine>, int>(
  (ref, profileId) => ref.watch(databaseProvider).routinesFor(profileId),
);

final routineStepsProvider = FutureProvider.autoDispose
    .family<List<RoutineStepEntry>, int>(
      (ref, routineId) =>
          ref.watch(databaseProvider).routineStepEntries(routineId),
    );
