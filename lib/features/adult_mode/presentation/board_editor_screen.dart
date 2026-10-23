import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/admin_queries.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers.dart';
import '../../boards/presentation/pictogram_image.dart';
import 'adult_providers.dart';
import 'pictogram_editor_screen.dart';
import 'pictogram_picker.dart';

/// Edita un tablero: ordenar (arrastrando), ocultar, quitar, agregar y crear.
class BoardEditorScreen extends ConsumerWidget {
  const BoardEditorScreen({
    super.key,
    required this.profileId,
    required this.categoryId,
    required this.title,
  });

  final int profileId;
  final int? categoryId;
  final String title;

  BoardKey get _key => (profileId: profileId, categoryId: categoryId);

  void _changed(WidgetRef ref) {
    ref.invalidate(boardEntriesProvider(_key));
    refreshBoards(ref);
  }

  Future<void> _reorder(
    WidgetRef ref,
    List<BoardEntry> list,
    int oldIndex,
    int newIndex,
  ) async {
    final ids = list.map((e) => e.item.id).toList();
    ids.insert(newIndex, ids.removeAt(oldIndex));
    await ref.read(databaseProvider).reorderItems(ids);
    _changed(ref);
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_a_photo_outlined),
              title: const Text('Crear pictograma propio'),
              subtitle: const Text('Con foto y voz de un familiar'),
              onTap: () => Navigator.pop(context, 'new'),
            ),
            ListTile(
              leading: const Icon(Icons.collections_outlined),
              title: const Text('Agregar uno existente'),
              onTap: () => Navigator.pop(context, 'existing'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || choice == null) return;
    if (choice == 'new') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PictogramEditorScreen(
            profileId: profileId,
            categoryId: categoryId,
          ),
        ),
      );
    } else {
      final picked = await showDialog<Pictogram>(
        context: context,
        builder: (_) => PictogramPickerDialog(
          loader: () => ref
              .read(databaseProvider)
              .pictogramsNotOnBoard(profileId, categoryId),
        ),
      );
      if (picked != null) {
        await ref
            .read(databaseProvider)
            .addToBoard(profileId, categoryId, picked.id);
      }
    }
    _changed(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(boardEntriesProvider(_key));
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: entries.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('Todavía no hay pictogramas'))
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Arrastrá para ordenar. El orden no cambia solo: '
                      'los chicos aprenden dónde está cada cosa.',
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                      onReorderItem: (a, b) => _reorder(ref, list, a, b),
                      children: [
                        for (final e in list)
                          _EntryTile(
                            key: ValueKey(e.item.id),
                            entry: e,
                            onChanged: () => _changed(ref),
                            categoryId: categoryId,
                            profileId: profileId,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({
    super.key,
    required this.entry,
    required this.onChanged,
    required this.categoryId,
    required this.profileId,
  });

  final BoardEntry entry;
  final VoidCallback onChanged;
  final int? categoryId;
  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = entry.pictogram;
    final hidden = entry.item.hidden;
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 56,
          child: Opacity(
            opacity: hidden ? 0.35 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PictogramImage(p),
            ),
          ),
        ),
        title: Text(
          p.labelEs,
          style: TextStyle(
            decoration: hidden ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: (p.photoPath != null || p.audioPath != null || hidden)
            ? Row(
                children: [
                  if (p.photoPath != null)
                    const _Badge(Icons.photo_camera_outlined),
                  if (p.audioPath != null) const _Badge(Icons.mic_none),
                  if (hidden) const Text('Oculto'),
                ],
              )
            : null,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 32),
          child: PopupMenuButton<String>(
            onSelected: (v) async {
              final db = ref.read(databaseProvider);
              switch (v) {
                case 'hide':
                  await db.setItemHidden(entry.item.id, !hidden);
                case 'edit':
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PictogramEditorScreen(
                        profileId: profileId,
                        categoryId: categoryId,
                        existing: p,
                      ),
                    ),
                  );
                case 'remove':
                  await db.removeFromBoard(entry.item.id);
              }
              onChanged();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'hide',
                child: Text(hidden ? 'Mostrar' : 'Ocultar'),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Text('Foto, voz y nombre'),
              ),
              const PopupMenuItem(
                value: 'remove',
                child: Text('Quitar del tablero'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: Icon(icon, size: 16),
  );
}
