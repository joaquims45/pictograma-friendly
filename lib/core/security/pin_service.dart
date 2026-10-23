import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacenamiento mínimo de clave/valor (permite testear sin plugin).
abstract class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class SecureKeyValueStore implements KeyValueStore {
  const SecureKeyValueStore([this._storage = const FlutterSecureStorage()]);
  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

/// PIN de 4 dígitos del modo adulto. Se guarda solo hash + sal, nunca el PIN.
class PinService {
  PinService(this._store, {Random? random})
    : _random = random ?? Random.secure();

  static const length = 4;
  static const _hashKey = 'pin_hash';
  static const _saltKey = 'pin_salt';

  final KeyValueStore _store;
  final Random _random;

  static bool isValidFormat(String pin) => RegExp(r'^\d{4}$').hasMatch(pin);

  Future<bool> hasPin() async => (await _store.read(_hashKey)) != null;

  Future<void> setPin(String pin) async {
    if (!isValidFormat(pin)) throw ArgumentError('El PIN debe tener 4 dígitos');
    final salt = base64Url.encode(
      List.generate(16, (_) => _random.nextInt(256)),
    );
    await _store.write(_saltKey, salt);
    await _store.write(_hashKey, _hash(salt, pin));
  }

  Future<bool> verify(String pin) async {
    final salt = await _store.read(_saltKey);
    final hash = await _store.read(_hashKey);
    if (salt == null || hash == null) return false;
    return _hash(salt, pin) == hash;
  }

  String _hash(String salt, String pin) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();
}
