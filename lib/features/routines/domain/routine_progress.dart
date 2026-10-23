import '../../../core/db/routine_queries.dart';

/// Estado de una rutina: qué toca ahora ("primero") y qué sigue ("después").
class RoutineProgress {
  RoutineProgress(this.steps);

  final List<RoutineStepEntry> steps;

  int get total => steps.length;
  int get doneCount => steps.where((s) => s.step.done).length;
  bool get isEmpty => steps.isEmpty;

  /// Primer paso sin hacer; `null` si no hay pasos o ya está todo listo.
  RoutineStepEntry? get current => steps.where((s) => !s.step.done).firstOrNull;

  /// El paso que viene después del actual.
  RoutineStepEntry? get next {
    final cur = current;
    if (cur == null) return null;
    final i = steps.indexOf(cur);
    return steps.skip(i + 1).where((s) => !s.step.done).firstOrNull;
  }

  bool get finished => steps.isNotEmpty && current == null;
}
