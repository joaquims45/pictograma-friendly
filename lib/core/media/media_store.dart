import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Fotos y audios propios, guardados en el almacenamiento privado de la app.
class MediaStore {
  Future<Directory> _dir(String name) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'media', name));
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
}
