import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

import '../../../core/db/admin_queries.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers.dart';
import '../../boards/presentation/pictogram_image.dart';

/// Crea un pictograma propio o edita nombre, foto y voz de uno existente.
class PictogramEditorScreen extends ConsumerStatefulWidget {
  const PictogramEditorScreen({
    super.key,
    required this.profileId,
    required this.categoryId,
    this.existing,
  });

  final int profileId;
  final int? categoryId;
  final Pictogram? existing;

  @override
  ConsumerState<PictogramEditorScreen> createState() =>
      _PictogramEditorScreenState();
}

class _PictogramEditorScreenState extends ConsumerState<PictogramEditorScreen> {
  final _label = TextEditingController();
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  String? _photoPath;
  String? _audioPath;
  int? _categoryId;
  List<Category> _categories = const [];
  bool _recording = false;
  bool _saving = false;

  /// Archivos nuevos de esta sesión: se borran si se descartan o se reemplazan.
  final _newFiles = <String>{};

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _label.text = e?.labelEs ?? '';
    _photoPath = e?.photoPath;
    _audioPath = e?.audioPath;
    _categoryId = widget.categoryId ?? e?.categoryId;
    final db = ref.read(databaseProvider);
    db.select(db.categories).get().then((v) {
      if (!mounted) return;
      setState(() {
        _categories = v;
        _categoryId ??= v.isEmpty ? null : v.first.id;
      });
    });
  }

  @override
  void dispose() {
    _label.dispose();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Sacar una foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (file == null) return;
      final saved = await ref.read(mediaStoreProvider).savePhoto(file.path);
      await _discardIfNew(_photoPath);
      _newFiles.add(saved);
      if (mounted) setState(() => _photoPath = saved);
    } catch (_) {
      _snack('No se pudo obtener la foto');
    }
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      final path = await _recorder.stop();
      if (!mounted) return;
      setState(() => _recording = false);
      if (path != null) setState(() => _audioPath = path);
      return;
    }
    if (!await _recorder.hasPermission()) {
      _snack('Falta el permiso del micrófono');
      return;
    }
    final path = await ref.read(mediaStoreProvider).newAudioPath();
    await _discardIfNew(_audioPath);
    _newFiles.add(path);
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    if (mounted) setState(() => _recording = true);
  }

  Future<void> _play() async {
    final path = _audioPath;
    if (path == null || !File(path).existsSync()) return;
    try {
      await _player.setFilePath(path);
      await _player.play();
    } catch (_) {
      _snack('No se pudo reproducir');
    }
  }

  Future<void> _discardIfNew(String? path) async {
    if (path != null && _newFiles.remove(path)) {
      await ref.read(mediaStoreProvider).deleteIfExists(path);
    }
  }

  Future<void> _save() async {
    final label = _label.text.trim();
    final categoryId = _categoryId;
    if (label.isEmpty || categoryId == null) return;
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final existing = widget.existing;
    if (existing == null) {
      final pic = await db.createCustomPictogram(
        label: label,
        categoryId: categoryId,
        photoPath: _photoPath,
        audioPath: _audioPath,
      );
      await db.addToBoard(widget.profileId, widget.categoryId, pic.id);
    } else {
      await db.updatePictogram(
        existing.id,
        label: label,
        photoPath: Value(_photoPath),
        audioPath: Value(_audioPath),
      );
      // Los archivos propios reemplazados ya no hacen falta.
      if (existing.photoPath != _photoPath) {
        await ref.read(mediaStoreProvider).deleteIfExists(existing.photoPath);
      }
      if (existing.audioPath != _audioPath) {
        await ref.read(mediaStoreProvider).deleteIfExists(existing.audioPath);
      }
    }
    _newFiles.clear();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _cancel() async {
    if (_recording) await _recorder.stop();
    for (final f in _newFiles.toList()) {
      await ref.read(mediaStoreProvider).deleteIfExists(f);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existing == null;
    final preview = Pictogram(
      id: 0,
      arasaacId: widget.existing?.arasaacId,
      labelEs: _label.text,
      categoryId: _categoryId ?? 0,
      assetPath: widget.existing?.assetPath,
      photoPath: _photoPath,
      audioPath: _audioPath,
      colorHex: null,
      isCustom: true,
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && !_saving) _cancel();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isNew ? 'Pictograma propio' : 'Editar pictograma'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _label,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(
                labelText: 'Lo que dice',
                helperText: 'Por ejemplo: upa, quiero agua, abuela',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (widget.categoryId == null && _categories.isNotEmpty)
              DropdownButtonFormField<int>(
                initialValue: _categoryId,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: [
                  for (final c in _categories)
                    DropdownMenuItem(value: c.id, child: Text(c.nameEs)),
                ],
                onChanged: (v) => setState(() => _categoryId = v),
              ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ColoredBox(
                    color: Colors.white,
                    child: PictogramImage(preview),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: Text(
                      _photoPath == null ? 'Agregar foto' : 'Cambiar foto',
                    ),
                  ),
                ),
                if (_photoPath != null)
                  IconButton(
                    tooltip: 'Quitar foto',
                    onPressed: () => setState(() => _photoPath = null),
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Voz de un familiar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Si hay una grabación, se usa en lugar de la voz del teléfono.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  style: _recording
                      ? FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                        )
                      : null,
                  onPressed: _toggleRecording,
                  icon: Icon(_recording ? Icons.stop : Icons.mic),
                  label: Text(
                    _recording
                        ? 'Detener'
                        : _audioPath == null
                        ? 'Grabar'
                        : 'Grabar de nuevo',
                  ),
                ),
                const SizedBox(width: 12),
                if (_audioPath != null && !_recording) ...[
                  OutlinedButton.icon(
                    onPressed: _play,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Escuchar'),
                  ),
                  IconButton(
                    tooltip: 'Quitar grabación',
                    onPressed: () => setState(() => _audioPath = null),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 56)),
              onPressed:
                  _label.text.trim().isEmpty ||
                      _categoryId == null ||
                      _recording
                  ? null
                  : _save,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
