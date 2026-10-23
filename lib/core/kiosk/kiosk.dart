import 'package:flutter/services.dart';

/// Fijado de pantalla de Android (screen pinning) para que no salgan sin querer.
class Kiosk {
  static const _channel = MethodChannel('ar.familia.pictograma/kiosk');

  static Future<void> start() => _call('start');
  static Future<void> stop() => _call('stop');

  static Future<void> _call(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } catch (_) {
      // Sin fijado disponible (p. ej. desactivado en Ajustes): la app sigue igual.
    }
  }
}
