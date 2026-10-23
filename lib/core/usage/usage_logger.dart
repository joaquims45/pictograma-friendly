import 'dart:async';

import '../db/app_database.dart';
import '../db/usage_queries.dart';

/// Registra toques para el adulto o el terapeuta, solo si está activado.
/// Nunca bloquea ni retrasa la voz: se guarda en segundo plano.
class UsageLogger {
  UsageLogger(this._db);

  final AppDatabase _db;
  bool _enabled = false;

  bool get enabled => _enabled;

  Future<void> load() async => _enabled = await _db.isUsageLogEnabled();

  Future<void> setEnabled(bool value) async {
    await _db.setUsageLogEnabled(value);
    _enabled = value;
  }

  void log(int profileId, int pictogramId, String source) {
    if (!_enabled) return;
    unawaited(
      _db.logUsage(profileId, pictogramId, source).catchError((Object _) {}),
    );
  }
}
