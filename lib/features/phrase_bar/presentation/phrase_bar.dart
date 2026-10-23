import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../boards/presentation/pictogram_image.dart';

/// Barra de frases: pictogramas en orden, "Hablar" y "Borrar" separados y grandes.
class PhraseBar extends ConsumerWidget {
  const PhraseBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrase = ref.watch(phraseProvider);
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 84,
              child: phrase.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: phrase.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 6),
                      itemBuilder: (_, i) => AspectRatio(
                        aspectRatio: 1,
                        child: PictogramImage(phrase[i]),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(110, 64)),
            onPressed: phrase.isEmpty
                ? null
                : () => ref.read(speakerProvider).speakPhrase(phrase),
            icon: const Icon(Icons.volume_up),
            label: const Text('Hablar'),
          ),
          const SizedBox(width: 28),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size(110, 64)),
            onPressed: phrase.isEmpty
                ? null
                : () => ref.read(phraseProvider.notifier).removeLast(),
            icon: const Icon(Icons.backspace_outlined),
            label: const Text('Borrar'),
          ),
        ],
      ),
    );
  }
}
