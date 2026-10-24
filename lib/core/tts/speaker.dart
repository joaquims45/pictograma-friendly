import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../db/app_database.dart';

/// Dice pictogramas en voz alta. Audio propio (familiar) tiene prioridad sobre TTS.
class Speaker {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    _ready = true;
    // Sin motor de voz instalado estas llamadas pueden no responder nunca.
    const limit = Duration(seconds: 3);
    try {
      for (final lang in const ['es-AR', 'es-US', 'es-ES']) {
        if (await _tts.isLanguageAvailable(lang).timeout(limit) == true) {
          await _tts.setLanguage(lang).timeout(limit);
          break;
        }
      }
      await _tts.setSpeechRate(0.42).timeout(limit); // calmo
      await _tts.setVolume(1.0).timeout(limit);
    } catch (_) {}
  }

  /// Cada pedido de voz lleva un número: si llega otro toque mientras se
  /// prepara éste, gana el último (nunca se cortan o se pisan dos voces).
  int _request = 0;

  Future<void> speakPictogram(Pictogram p) async {
    final id = ++_request;
    await stop();
    if (id != _request) return;
    final audio = p.audioPath;
    if (audio != null && File(audio).existsSync()) {
      try {
        await _player.setFilePath(audio);
        if (id != _request) return;
        await _player.play();
        return;
      } catch (_) {}
    }
    if (id != _request) return;
    await _guard(_tts.speak(p.labelEs));
  }

  Future<void> speakPhrase(List<Pictogram> items) async {
    if (items.isEmpty) return;
    final id = ++_request;
    await stop();
    if (id != _request) return;
    await _guard(_tts.speak(items.map((p) => p.labelEs).join(', ')));
  }

  Future<void> stop() async {
    await _guard(_tts.stop());
    await _guard(_player.stop());
  }

  /// Si el motor de voz no responde, la app no se queda esperando.
  Future<void> _guard(Future<dynamic> call) async {
    try {
      await call.timeout(const Duration(seconds: 2));
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}
