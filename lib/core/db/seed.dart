import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import 'app_database.dart';

const _categoryNames = {
  'necesidades': 'Necesidades',
  'comida': 'Comida',
  'bebida': 'Bebida',
  'juegos': 'Juegos',
  'emociones': 'Emociones',
  'cuerpo': 'Cuerpo y dolor',
  'personas': 'Personas',
  'acciones': 'Acciones',
};

/// Tablero plano de las mellizas (orden fijo, pictogramas grandes).
const _twinsBoard = [
  'quiero agua',
  'quiero comer',
  'quiero jugar',
  'me duele',
  'más',
  'terminado',
];

/// Carga el paquete inicial y los perfiles la primera vez que se abre la app.
Future<void> seedIfEmpty(AppDatabase db, {AssetBundle? bundle}) async {
  final existing = await db.select(db.profiles).get();
  if (existing.isNotEmpty) return;

  final raw = await (bundle ?? rootBundle).loadString('assets/pictograms.json');
  final data = jsonDecode(raw) as Map<String, dynamic>;
  final colors = (data['categories'] as Map).cast<String, String>();
  final items = (data['pictograms'] as List).cast<Map<String, dynamic>>();

  await db.transaction(() async {
    final catIds = <String, int>{};
    for (final key in colors.keys) {
      catIds[key] = await db
          .into(db.categories)
          .insert(
            CategoriesCompanion.insert(
              key: key,
              nameEs: _categoryNames[key] ?? key,
              colorHex: colors[key]!,
            ),
          );
    }

    final picIds = <int, int>{}; // id ARASAAC -> id local
    final picByText = <String, int>{};
    for (final it in items) {
      final id = await db
          .into(db.pictograms)
          .insert(
            PictogramsCompanion.insert(
              arasaacId: Value(it['id'] as int),
              labelEs: it['text'] as String,
              categoryId: catIds[it['category']]!,
              assetPath: Value(it['asset'] as String),
              colorHex: Value(it['color'] as String),
            ),
          );
      picIds[it['id'] as int] = id;
      picByText.putIfAbsent(it['text'] as String, () => id);
    }

    final twins = await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(name: 'Mellizas', gridSize: const Value(2)),
        );
    final kid = await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            name: 'Sobrino',
            gridSize: const Value(3),
            phraseBarEnabled: const Value(true),
            nestedCategories: const Value(true),
          ),
        );

    var pos = 0;
    for (final text in _twinsBoard) {
      final id = picByText[text];
      if (id == null) continue;
      await db
          .into(db.boardItems)
          .insert(
            BoardItemsCompanion.insert(
              profileId: twins,
              pictogramId: id,
              position: pos++,
            ),
          );
    }

    var catPos = 0;
    for (final id in catIds.values) {
      await db
          .into(db.profileCategories)
          .insert(
            ProfileCategoriesCompanion.insert(
              profileId: kid,
              categoryId: id,
              position: catPos++,
            ),
          );
    }

    final perCategory = <String, int>{};
    for (final it in items) {
      final cat = it['category'] as String;
      final p = perCategory[cat] ?? 0;
      perCategory[cat] = p + 1;
      await db
          .into(db.boardItems)
          .insert(
            BoardItemsCompanion.insert(
              profileId: kid,
              categoryId: Value(catIds[cat]),
              pictogramId: picIds[it['id'] as int]!,
              position: p,
            ),
          );
    }
  });
}
