import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/admin_queries.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../boards/presentation/pictogram_tile.dart';
import 'adult_providers.dart';
import 'board_editor_screen.dart';

/// Ajustes de un perfil: grilla, barra de frases y qué tableros/categorías tiene.
class ProfileAdminScreen extends ConsumerWidget {
  const ProfileAdminScreen({super.key, required this.profileId});
  final int profileId;

  Future<void> _save(
    WidgetRef ref, {
    int? gridSize,
    bool? phraseBarEnabled,
  }) async {
    await ref
        .read(databaseProvider)
        .updateProfileSettings(
          profileId,
          gridSize: gridSize,
          phraseBarEnabled: phraseBarEnabled,
        );
    refreshBoards(ref);
  }

  Future<void> _newCategory(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<({String name, String color})>(
      context: context,
      builder: (_) => const _NewCategoryDialog(),
    );
    if (result == null) return;
    await ref
        .read(databaseProvider)
        .createCategory(
          profileId: profileId,
          name: result.name,
          colorHex: result.color,
        );
    ref.invalidate(categoryLinksProvider(profileId));
    refreshBoards(ref);
  }

  Future<void> _reorder(
    WidgetRef ref,
    List<CategoryLink> links,
    int oldIndex,
    int newIndex,
  ) async {
    final ids = links.map((l) => l.link.id).toList();
    ids.insert(newIndex, ids.removeAt(oldIndex));
    await ref.read(databaseProvider).reorderCategories(ids);
    ref.invalidate(categoryLinksProvider(profileId));
    refreshBoards(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref
        .watch(profilesProvider)
        .value
        ?.where((p) => p.id == profileId)
        .firstOrNull;
    if (profile == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(title: Text(profile.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Tamaño de la grilla'),
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              for (final n in const [1, 2, 3, 4])
                ButtonSegment(value: n, label: Text('${n}x$n')),
            ],
            selected: {profile.gridSize},
            onSelectionChanged: (s) => _save(ref, gridSize: s.first),
          ),
          const SizedBox(height: 4),
          Text(
            'Cantidad de pictogramas por fila y columna. Con 1x1 se ve de a uno.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Barra de frases'),
            subtitle: const Text('Permite armar frases juntando pictogramas'),
            value: profile.phraseBarEnabled,
            onChanged: (v) => _save(ref, phraseBarEnabled: v),
          ),
          const Divider(height: 32),
          if (!profile.nestedCategories) ...[
            const _SectionTitle('Tablero'),
            Card(
              child: ListTile(
                title: const Text('Editar pictogramas'),
                subtitle: const Text(
                  'Ordenar, ocultar, agregar y crear propios',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BoardEditorScreen(
                      profileId: profileId,
                      categoryId: null,
                      title: 'Tablero de ${profile.name}',
                    ),
                  ),
                ),
              ),
            ),
          ] else
            ..._categorySection(context, ref),
        ],
      ),
    );
  }

  List<Widget> _categorySection(BuildContext context, WidgetRef ref) {
    final links = ref.watch(categoryLinksProvider(profileId));
    return [
      Row(
        children: [
          const Expanded(child: _SectionTitle('Categorías')),
          TextButton.icon(
            onPressed: () => _newCategory(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Nueva'),
          ),
        ],
      ),
      const Text('Mantené presionado y arrastrá para cambiar el orden.'),
      const SizedBox(height: 8),
      links.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Text('Error: $e'),
        data: (list) => ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: true,
          onReorderItem: (a, b) => _reorder(ref, list, a, b),
          children: [
            for (final l in list)
              Card(
                key: ValueKey(l.link.id),
                color: colorFromHex(l.category.colorHex, AppColors.surface),
                child: ListTile(
                  title: Text(
                    l.category.nameEs,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: l.link.hidden
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BoardEditorScreen(
                        profileId: profileId,
                        categoryId: l.category.id,
                        title: l.category.nameEs,
                      ),
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Switch(
                      value: !l.link.hidden,
                      onChanged: (visible) async {
                        await ref
                            .read(databaseProvider)
                            .setCategoryHidden(l.link.id, !visible);
                        ref.invalidate(categoryLinksProvider(profileId));
                        refreshBoards(ref);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    ),
  );
}

class _NewCategoryDialog extends StatefulWidget {
  const _NewCategoryDialog();

  @override
  State<_NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<_NewCategoryDialog> {
  final _name = TextEditingController();
  String _color = '#CFE0EC';

  static const _options = [
    '#CFE0EC',
    '#F2DDC4',
    '#CDE6E3',
    '#E3D6EC',
    '#F2D5D9',
    '#F0E3C6',
    '#D9E7CF',
    '#DADDE6',
  ];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva categoría'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Nombre'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in _options)
                GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorFromHex(c, AppColors.surface),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: c == _color ? AppColors.ink : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _name.text.trim().isEmpty
              ? null
              : () => Navigator.pop(context, (
                  name: _name.text.trim(),
                  color: _color,
                )),
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
