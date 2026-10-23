import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/usage_queries.dart';
import '../../../core/providers.dart';
import 'backup_screen.dart';

final _usageProvider = FutureProvider.autoDispose<UsageSummary>(
  (ref) => ref
      .watch(databaseProvider)
      .usageSummary(since: DateTime.now().subtract(const Duration(days: 7))),
);

final _eventCountProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(databaseProvider).usageEventCount(),
);

/// Registro de uso opcional, para el adulto o el terapeuta. Apagado por defecto.
class UsageLogScreen extends ConsumerStatefulWidget {
  const UsageLogScreen({super.key});

  @override
  ConsumerState<UsageLogScreen> createState() => _UsageLogScreenState();
}

class _UsageLogScreenState extends ConsumerState<UsageLogScreen> {
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _refresh() {
    ref.invalidate(_usageProvider);
    ref.invalidate(_eventCountProvider);
  }

  Future<void> _toggle(bool value) async {
    await ref.read(usageLoggerProvider).setEnabled(value);
    setState(() {});
  }

  Future<void> _export() async {
    try {
      final rows = await ref.read(databaseProvider).usageExportRows();
      final saved = await FilePicker.saveFile(
        fileName: 'uso_pictogramas.csv',
        bytes: Uint8List.fromList(csvBytes(usageToCsv(rows))),
        mimeType: 'text/csv',
        dialogTitle: 'Guardar registro de uso',
      );
      if (mounted && saved != null) _snack('Registro guardado');
    } catch (_) {
      if (mounted) _snack('No se pudo exportar');
    }
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Borrar el registro?'),
        content: const Text('Se borran todos los toques registrados.'),
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
    await ref.read(databaseProvider).clearUsageLog();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.read(usageLoggerProvider).enabled;
    final summary = ref.watch(_usageProvider);
    final total = ref.watch(_eventCountProvider).value ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de uso')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Guardar registro de uso'),
            subtitle: const Text(
              'Anota qué pictograma se toca y cuándo. Queda solo en este '
              'teléfono, no se envía a ningún lado. Está apagado salvo que lo '
              'actives.',
            ),
            value: enabled,
            onChanged: _toggle,
          ),
          const Divider(height: 32),
          const Text(
            'Últimos 7 días',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          summary.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => Text('Error: $e'),
            data: (s) => s.total == 0
                ? Text(
                    enabled
                        ? 'Todavía no hay toques registrados.'
                        : 'No hay datos. Activá el registro para empezar.',
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${s.total} toques en total'),
                      const SizedBox(height: 8),
                      for (final u in s.top)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(u.label),
                          trailing: Text(
                            '${u.count}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: total == 0 ? null : _export,
            icon: const Icon(Icons.table_view),
            label: const Text('Exportar a planilla (CSV)'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: total == 0 ? null : _clear,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Borrar registro'),
          ),
        ],
      ),
    );
  }
}
