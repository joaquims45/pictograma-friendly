import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/admin_queries.dart';
import '../../../core/providers.dart';

/// Lecturas del modo adulto. Son autoDispose: siempre reflejan lo último guardado.
final categoryLinksProvider = FutureProvider.autoDispose
    .family<List<CategoryLink>, int>(
      (ref, profileId) =>
          ref.watch(databaseProvider).profileCategoryLinks(profileId),
    );

final boardEntriesProvider = FutureProvider.autoDispose
    .family<List<BoardEntry>, BoardKey>(
      (ref, key) => ref
          .watch(databaseProvider)
          .boardEntries(key.profileId, key.categoryId),
    );
