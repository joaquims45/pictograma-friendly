import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/routine_queries.dart';
import '../../../core/providers.dart';
import '../../boards/presentation/pictogram_image.dart';
import '../../routines/presentation/routine_providers.dart';
import 'pictogram_picker.dart';

/// Arma una rutina: pasos en orden (arrastrando), agregar y quitar.
class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({super.key, required this.routine});
  final Routine routine;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  late String _name = widget.routine.name;

  int get _id => widget.routine.id;

  void _refresh() => ref.invalidate(routineStepsProvider(_id));

  Future<void> _rename() async {
    final name = await askForText(
      context,
      title: 'Nombre de la rutina',
      initial: _name,
    );
    if (name == null) return;
    await ref.read(databaseProvider).renameRoutine(_id, name);
    ref.invalidate(routinesProvider(widget.routine.profileId));
    setState(() => _name = name);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Borrar la rutina?'),
        content: Text('Se borra "$_name" con todos sus pasos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(databaseProvider).deleteRoutine(_id);
    ref.invalidate(routinesProvider(widget.routine.profileId));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _addStep() async {
    final db = ref.read(databaseProvider);
    final picked = await showDialog<Pictogram>(
      context: context,
      builder: (_) => PictogramPickerDialog(
        title: 'Agregar paso',
        loader: db.allPictograms,
      ),
    );
    if (picked == null) return;
    await db.addRoutineStep(_id, picked.id);
    _refresh();
  }

  Future<void> _reorder(
    List<RoutineStepEntry> list,
    int oldIndex,
    int newIndex,
  ) async {
    final ids = list.map((e) => e.step.id).toList();
    ids.insert(newIndex, ids.removeAt(oldIndex));
    await ref.read(databaseProvider).reorderRoutineSteps(ids);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(routineStepsProvider(_id));
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        actions: [
          IconButton(
            tooltip: 'Cambiar nombre',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _rename,
          ),
          IconButton(
            tooltip: 'Borrar rutina',
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addStep,
        icon: const Icon(Icons.add),
        label: const Text('Agregar paso'),
      ),
      body: steps.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                'Los pasos se hacen en este orden. Mantené presionado y '
                'arrastrá para cambiarlo.',
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Todavía no hay pasos')),
              )
            else
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorderItem: (a, b) => _reorder(list, a, b),
                children: [
                  for (var i = 0; i < list.length; i++)
                    Card(
                      key: ValueKey(list[i].step.id),
                      child: ListTile(
                        leading: SizedBox(
                          width: 56,
                          height: 56,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: PictogramImage(list[i].pictogram),
                          ),
                        ),
                        title: Text('${i + 1}. ${list[i].pictogram.labelEs}'),
                        subtitle: list[i].step.done
                            ? const Text('Hecho')
                            : null,
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: IconButton(
                            tooltip: 'Quitar paso',
                            icon: const Icon(Icons.close),
                            onPressed: () async {
                              await ref
                                  .read(databaseProvider)
                                  .removeRoutineStep(list[i].step.id);
                              _refresh();
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            if (list.any((e) => e.step.done))
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(databaseProvider).resetRoutine(_id);
                  _refresh();
                },
                icon: const Icon(Icons.replay),
                label: const Text('Reiniciar progreso'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Diálogo simple para pedir un texto (nombre de rutina, etc.).
Future<String?> askForText(
  BuildContext context, {
  required String title,
  String initial = '',
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Nombre'),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: controller.text.trim().isEmpty
                ? null
                : () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),
  );
}
