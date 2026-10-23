import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/kiosk/kiosk.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../phrase_bar/presentation/phrase_bar.dart';
import '../../routines/presentation/routine_list_screen.dart';
import '../../routines/presentation/routine_providers.dart';
import 'pictogram_tile.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key, required this.profile});
  final Profile profile;

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    Kiosk.start();
  }

  Future<void> _exit() async {
    await Kiosk.stop();
    if (mounted) Navigator.of(context).pop();
  }

  Profile get profile => widget.profile;

  void _onTap(Pictogram p) {
    ref.read(speakerProvider).speakPictogram(p);
    if (profile.phraseBarEnabled) ref.read(phraseProvider.notifier).add(p);
  }

  @override
  Widget build(BuildContext context) {
    final cats = profile.nestedCategories
        ? ref.watch(profileCategoriesProvider(profile.id)).value ??
              const <Category>[]
        : const <Category>[];
    final activeCat = profile.nestedCategories
        ? (_categoryId ?? (cats.isEmpty ? null : cats.first.id))
        : null;
    final routines =
        ref.watch(routinesProvider(profile.id)).value ?? const <Routine>[];
    final board = ref.watch(
      boardProvider((profileId: profile.id, categoryId: activeCat)),
    );

    final grid = board.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (items) => GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: profile.gridSize,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: profile.gridSize >= 3 ? 0.78 : 0.9,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) =>
            PictogramTile(pictogram: items[i], onTap: () => _onTap(items[i])),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                if (routines.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => openRoutines(context, profile, routines),
                    icon: const Icon(Icons.checklist, size: 28),
                    label: const Text('Rutinas'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                const Spacer(),
                _ExitLock(onExit: _exit),
              ],
            ),
            if (profile.phraseBarEnabled) const PhraseBar(),
            Expanded(
              child: Row(
                children: [
                  if (cats.isNotEmpty)
                    _CategoryRail(
                      categories: cats,
                      selected: activeCat,
                      onSelect: (id) => setState(() => _categoryId = id),
                    ),
                  Expanded(child: grid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Categorías siempre en el mismo lugar (previsibilidad).
class _CategoryRail extends StatelessWidget {
  const _CategoryRail({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });
  final List<Category> categories;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final c in categories)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onSelect(c.id),
                child: Container(
                  height: 64,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: colorFromHex(c.colorHex, AppColors.surface),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: c.id == selected
                          ? AppColors.ink
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Text(
                    c.nameEs,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Candado discreto: hay que mantenerlo presionado 3 segundos para salir.
class _ExitLock extends StatelessWidget {
  const _ExitLock({required this.onExit});
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(
                duration: const Duration(seconds: 3),
              ),
              (r) => r.onLongPress = onExit,
            ),
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Icon(Icons.lock_outline, size: 28, color: Color(0x668A93A0)),
      ),
    );
  }
}
