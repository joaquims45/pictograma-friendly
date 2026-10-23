import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backup/backup_service.dart';
import '../../../core/providers.dart';

/// Copia de seguridad y restauración a un archivo `.zip`.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final bytes = await ref.read(backupServiceProvider).createBackup();
      final saved = await FilePicker.saveFile(
        fileName: BackupService.fileName(),
        bytes: bytes,
        mimeType: 'application/zip',
        dialogTitle: 'Guardar copia de seguridad',
      );
      if (mounted && saved != null) _snack('Copia guardada');
    } catch (_) {
      if (mounted) _snack('No se pudo crear la copia');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
      dialogTitle: 'Elegir copia de seguridad',
    );
    if (files.isEmpty || !mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Restaurar la copia?'),
        content: const Text(
          'Se reemplazan TODOS los datos de este teléfono (perfiles, '
          'pictogramas propios, rutinas y registro de uso) por los de la copia. '
          'No se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final bytes = await files.first.readAsBytes();
      await ref.read(backupServiceProvider).restore(bytes);
      await ref.read(usageLoggerProvider).load();
      refreshBoards(ref);
      if (mounted) _snack('Copia restaurada');
    } on BackupException catch (e) {
      if (mounted) _snack(e.message);
    } catch (_) {
      if (mounted) _snack('No se pudo restaurar la copia');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Copia de seguridad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Guarda en un archivo todo lo que cargaste: perfiles, tableros, '
            'pictogramas propios con sus fotos y voces, rutinas y el registro '
            'de uso. Sirve para pasar la app a otro teléfono o para no perder '
            'nada si se rompe este.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'El PIN no va en la copia: en el teléfono nuevo se crea uno nuevo. '
            'El archivo contiene fotos y voces de la familia: guardalo en un '
            'lugar de confianza.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
            onPressed: _busy ? null : _export,
            icon: const Icon(Icons.save_alt),
            label: const Text('Crear copia'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 56)),
            onPressed: _busy ? null : _import,
            icon: const Icon(Icons.restore),
            label: const Text('Restaurar copia'),
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

/// Texto UTF-8 con BOM para que Excel abra bien las tildes del CSV.
List<int> csvBytes(String csv) => [0xEF, 0xBB, 0xBF, ...utf8.encode(csv)];
