import 'package:drift/drift.dart';

import 'app_database.dart';

const usageLogEnabledKey = 'usage_log_enabled';

typedef UsageCount = ({String label, int count});

typedef UsageSummary = ({int total, List<UsageCount> top});

extension SettingsQueries on AppDatabase {
  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => into(
    appSettings,
  ).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));

  /// Apagado por defecto: los datos de uso solo se guardan si el adulto lo activa.
  Future<bool> isUsageLogEnabled() async =>
      (await getSetting(usageLogEnabledKey)) == 'true';

  Future<void> setUsageLogEnabled(bool enabled) =>
      setSetting(usageLogEnabledKey, enabled.toString());
}

extension UsageQueries on AppDatabase {
  Future<void> logUsage(int profileId, int pictogramId, String source) =>
      into(usageLog).insert(
        UsageLogCompanion.insert(
          profileId: profileId,
          pictogramId: pictogramId,
          source: source,
          at: DateTime.now(),
        ),
      );

  /// Toques desde [since], con los más usados primero.
  Future<UsageSummary> usageSummary({
    required DateTime since,
    int? profileId,
    int topN = 10,
  }) async {
    final query =
        select(usageLog).join([
          innerJoin(pictograms, pictograms.id.equalsExp(usageLog.pictogramId)),
        ])..where(
          usageLog.at.isBiggerOrEqualValue(since) &
              (profileId == null
                  ? const Constant(true)
                  : usageLog.profileId.equals(profileId)),
        );
    final rows = await query.get();
    final counts = <String, int>{};
    for (final r in rows) {
      final label = r.readTable(pictograms).labelEs;
      counts[label] = (counts[label] ?? 0) + 1;
    }
    final top =
        counts.entries.map((e) => (label: e.key, count: e.value)).toList()
          ..sort((a, b) => b.count.compareTo(a.count));
    return (total: rows.length, top: top.take(topN).toList());
  }

  Future<int> usageEventCount() async {
    final count = usageLog.id.count();
    final row = await (selectOnly(usageLog)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  /// Todos los eventos, del más viejo al más nuevo, con nombres legibles.
  Future<List<UsageExportRow>> usageExportRows() async {
    final query = select(usageLog).join([
      innerJoin(pictograms, pictograms.id.equalsExp(usageLog.pictogramId)),
      innerJoin(profiles, profiles.id.equalsExp(usageLog.profileId)),
    ])..orderBy([OrderingTerm.asc(usageLog.at)]);
    final rows = await query.get();
    return rows
        .map(
          (r) => (
            at: r.readTable(usageLog).at,
            profile: r.readTable(profiles).name,
            pictogram: r.readTable(pictograms).labelEs,
            source: r.readTable(usageLog).source,
          ),
        )
        .toList();
  }

  Future<void> clearUsageLog() => delete(usageLog).go();
}

typedef UsageExportRow = ({
  DateTime at,
  String profile,
  String pictogram,
  String source,
});

/// CSV para abrir en una planilla (separado por comas, texto entre comillas).
String usageToCsv(List<UsageExportRow> rows) {
  String q(String v) => '"${v.replaceAll('"', '""')}"';
  final buf = StringBuffer('fecha_hora,perfil,pictograma,origen\r\n');
  for (final r in rows) {
    buf.write(
      '${r.at.toIso8601String()},${q(r.profile)},${q(r.pictogram)},${q(r.source)}\r\n',
    );
  }
  return buf.toString();
}
