import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/theme/app_theme.dart';
import 'routine_providers.dart';
import 'routine_screen.dart';

/// Abre la agenda de un perfil: directo a la rutina si hay una sola.
void openRoutines(BuildContext context, Profile profile, List<Routine> list) {
  if (list.isEmpty) return;
  final route = list.length == 1
      ? MaterialPageRoute<void>(
          builder: (_) => RoutineScreen(routine: list.first),
        )
      : MaterialPageRoute<void>(
          builder: (_) => RoutineListScreen(profile: profile),
        );
  Navigator.of(context).push(route);
}

class RoutineListScreen extends ConsumerWidget {
  const RoutineListScreen({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routinesProvider(profile.id));
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rutinas'),
          backgroundColor: Colors.transparent,
        ),
        body: routines.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (list) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var i = 0; i < list.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoutineScreen(routine: list[i]),
                      ),
                    ),
                    child: Container(
                      height: 110,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.pastels.values.elementAt(
                          i % AppColors.pastels.length,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        list[i].name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
