import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../about/presentation/about_screen.dart';
import '../../boards/presentation/board_screen.dart';

class ProfilePickerScreen extends ConsumerWidget {
  const ProfilePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Quién usa la app?'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Acerca de',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
        ],
      ),
      body: profiles.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final p in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BoardScreen(profile: p)),
                  ),
                  child: Container(
                    height: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.pastels.values.elementAt(
                        (p.id - 1) % AppColors.pastels.length,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
