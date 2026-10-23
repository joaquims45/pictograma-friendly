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

/// Tablero plano del perfil simple (orden fijo, pictogramas grandes).
const _simpleBoard = [
  'quiero agua',
  'quiero comer',
  'quiero jugar',
  'me duele',
  'upa',
  'más',
  'terminado',
];

/// Carga el paquete inicial y los perfiles la primera vez que se abre la app.
/// Perfil 1: tablero simple y grande. Perfil 2: grilla más densa con categorías
/// y barra de frases. Los nombres se cambian desde el modo adulto.
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

    final simple = await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(name: 'Perfil 1', gridSize: const Value(2)),
        );
    final dense = await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            name: 'Perfil 2',
            gridSize: const Value(3),
            phraseBarEnabled: const Value(true),
            nestedCategories: const Value(true),
          ),
        );

    var pos = 0;
    for (final text in _simpleBoard) {
      final id = picByText[text];
      if (id == null) continue;
      await db
          .into(db.boardItems)
          .insert(
            BoardItemsCompanion.insert(
              profileId: simple,
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
              profileId: dense,
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
              profileId: dense,
              categoryId: Value(catIds[cat]),
              pictogramId: picIds[it['id'] as int]!,
              position: p,
            ),
          );
    }
  });
}
