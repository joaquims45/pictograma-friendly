import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Fotos y audios propios, guardados en el almacenamiento privado de la app.
class MediaStore {
  /// [root] permite usar otra carpeta (tests y restauración de copias).
  MediaStore({this._root});

  final Directory? _root;

  Future<Directory> rootDir() async {
    final dir =
        _root ??
        Directory(
          p.join((await getApplicationDocumentsDirectory()).path, 'media'),
        );
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  Future<Directory> _dir(String name) async {
    final dir = Directory(p.join((await rootDir()).path, name));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  String _stamp() => DateTime.now().microsecondsSinceEpoch.toString();

  /// Copia la foto elegida (cámara/galería) a la carpeta privada.
  Future<String> savePhoto(String sourcePath) async {
    final dir = await _dir('photos');
    final dest = p.join(dir.path, '${_stamp()}${p.extension(sourcePath)}');
    await File(sourcePath).copy(dest);
    return dest;
  }

  /// Ruta donde se grabará un nuevo audio.
  Future<String> newAudioPath() async {
    final dir = await _dir('audio');
    return p.join(dir.path, '${_stamp()}.m4a');
  }

  Future<void> deleteIfExists(String? path) async {
    if (path == null) return;
    final f = File(path);
    if (f.existsSync()) await f.delete();
  }

  /// Ruta relativa a la carpeta de medios (`photos/x.jpg`), o `null` si el
  /// archivo no existe o está fuera de ella.
  Future<String?> relativePath(String? fullPath) async {
    if (fullPath == null || !File(fullPath).existsSync()) return null;
    final root = (await rootDir()).path;
    if (!p.isWithin(root, fullPath)) return null;
    return p.posix.joinAll(p.split(p.relative(fullPath, from: root)));
  }

  /// Ruta completa para una ruta relativa guardada en una copia.
  Future<String> fullPath(String relative) async =>
      p.joinAll([(await rootDir()).path, ...p.posix.split(relative)]);

  Future<void> writeRelative(String relative, List<int> bytes) async {
    final file = File(await fullPath(relative));
    file.parent.createSync(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  }

  /// Borra los archivos de medios que ya no usa ningún pictograma.
  Future<void> deleteUnreferenced(Set<String> keepFullPaths) async {
    final root = await rootDir();
    final keep = keepFullPaths.map(p.normalize).toSet();
    for (final entity in root.listSync(recursive: true)) {
      if (entity is File && !keep.contains(p.normalize(entity.path))) {
        await entity.delete();
      }
    }
  }
}
