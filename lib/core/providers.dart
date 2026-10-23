import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db/app_database.dart';
import 'db/queries.dart';
import 'db/seed.dart';
import 'tts/speaker.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final speakerProvider = Provider<Speaker>((ref) {
  final s = Speaker();
  ref.onDispose(s.dispose);
  return s;
});

/// Siembra datos y prepara la voz antes de mostrar la app.
final bootstrapProvider = FutureProvider<void>((ref) async {
  await seedIfEmpty(ref.read(databaseProvider));
  // La voz se prepara en segundo plano: nunca debe bloquear el arranque.
  unawaited(ref.read(speakerProvider).init());
});

final profilesProvider = FutureProvider<List<Profile>>(
  (ref) => ref.watch(databaseProvider).allProfiles(),
);

final profileCategoriesProvider = FutureProvider.family<List<Category>, int>(
  (ref, profileId) =>
      ref.watch(databaseProvider).categoriesForProfile(profileId),
);

typedef BoardKey = ({int profileId, int? categoryId});

final boardProvider = FutureProvider.family<List<Pictogram>, BoardKey>(
  (ref, key) => ref
      .watch(databaseProvider)
      .boardPictograms(key.profileId, key.categoryId),
);

/// Frase en construcción (perfil con barra de frases). Se descarta al salir.
class PhraseNotifier extends Notifier<List<Pictogram>> {
  @override
  List<Pictogram> build() => const [];
  void add(Pictogram p) => state = [...state, p];
  void removeLast() {
    if (state.isNotEmpty) state = state.sublist(0, state.length - 1);
  }
}

final phraseProvider =
    NotifierProvider.autoDispose<PhraseNotifier, List<Pictogram>>(
      PhraseNotifier.new,
    );
