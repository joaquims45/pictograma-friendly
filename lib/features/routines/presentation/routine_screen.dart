import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/routine_queries.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/forgiving_tap.dart';
import '../../boards/presentation/pictogram_image.dart';
import '../../boards/presentation/pictogram_tile.dart';
import '../domain/routine_progress.dart';
import 'routine_providers.dart';

/// Agenda visual: "Primero" (lo que toca ahora), "Después" y el tilde de listo.
/// Sin sonidos ni animaciones de premio: terminar es un estado tranquilo.
class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key, required this.routine});
  final Routine routine;

  Future<void> _setDone(WidgetRef ref, RoutineStepEntry e, bool done) async {
    await ref.read(databaseProvider).setStepDone(e.step.id, done);
    if (done) {
      ref
          .read(usageLoggerProvider)
          .log(routine.profileId, e.pictogram.id, 'routine');
    }
    ref.invalidate(routineStepsProvider(routine.id));
  }

  Future<void> _restart(WidgetRef ref) async {
    await ref.read(databaseProvider).resetRoutine(routine.id);
    ref.invalidate(routineStepsProvider(routine.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(routineStepsProvider(routine.id));
    final all = steps.value;
    final hasDone = all != null && all.any((e) => e.step.done);
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        appBar: AppBar(
          title: Text(routine.name),
          backgroundColor: Colors.transparent,
          actions: [
            // Arriba y aparte de "Listo": un doble toque no puede deshacer.
            if (hasDone)
              IconButton(
                tooltip: 'Volver al paso anterior',
                icon: const Icon(Icons.undo),
                onPressed: () =>
                    _setDone(ref, all.lastWhere((e) => e.step.done), false),
              ),
          ],
        ),
        body: SafeArea(
          child: steps.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) {
              final progress = RoutineProgress(list);
              if (progress.isEmpty) {
                return const Center(
                  child: Text('Esta rutina todavía no tiene pasos'),
                );
              }
              if (progress.finished) {
                return _Finished(onRestart: () => _restart(ref));
              }
              return _Active(
                progress: progress,
                onDone: () => _setDone(ref, progress.current!, true),
                onSpeak: (p) => ref.read(speakerProvider).speakPictogram(p),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Active extends StatelessWidget {
  const _Active({
    required this.progress,
    required this.onDone,
    required this.onSpeak,
  });

  final RoutineProgress progress;
  final VoidCallback onDone;
  final ValueChanged<Pictogram> onSpeak;

  @override
  Widget build(BuildContext context) {
    final current = progress.current!;
    final next = progress.next;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          _Strip(progress: progress),
          const SizedBox(height: 12),
          const _Heading('Primero', size: 24),
          Expanded(
            flex: 5,
            child: Center(
              child: AspectRatio(
                aspectRatio: 0.95,
                child: PictogramTile(
                  pictogram: current.pictogram,
                  onTap: () => onSpeak(current.pictogram),
                ),
              ),
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 8),
            const _Heading('Después', size: 18),
            Expanded(
              flex: 3,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 0.95,
                  child: Opacity(
                    opacity: 0.8,
                    child: PictogramTile(
                      pictogram: next.pictogram,
                      onTap: () => onSpeak(next.pictogram),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Toque tolerante (dos dedos, deslizar un poco). El intervalo largo
          // evita que un doble toque salte dos pasos de golpe.
          SizedBox(
            width: double.infinity,
            height: 72,
            child: ForgivingTap(
              semanticLabel: 'Listo',
              minInterval: const Duration(milliseconds: 800),
              onTap: onDone,
              builder: (context, pressed) {
                final color = Theme.of(context).colorScheme.primary;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: pressed
                        ? Color.lerp(color, Colors.black, 0.2)
                        : color,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 32, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Listo',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Tira de miniaturas con todos los pasos; los hechos quedan atenuados con tilde.
class _Strip extends StatelessWidget {
  const _Strip({required this.progress});
  final RoutineProgress progress;

  @override
  Widget build(BuildContext context) {
    final currentId = progress.current?.step.id;
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: progress.steps.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final e = progress.steps[i];
          final isCurrent = e.step.id == currentId;
          return Container(
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCurrent ? AppColors.ink : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: e.step.done ? 0.35 : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: PictogramImage(e.pictogram),
                    ),
                  ),
                  if (e.step.done)
                    const Center(
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF4F7A5A),
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {required this.size});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.w700),
  );
}

class _Finished extends StatelessWidget {
  const _Finished({required this.onRestart});
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 120,
              color: Color(0xFF4F7A5A),
            ),
            const SizedBox(height: 16),
            const Text(
              'Terminamos',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.replay),
              label: const Text('Empezar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}
