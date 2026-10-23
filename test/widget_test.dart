import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pictograma_friendly/core/db/app_database.dart';
import 'package:pictograma_friendly/core/db/queries.dart';
import 'package:pictograma_friendly/core/db/seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seed crea perfiles y tableros; es idempotente', () async {
    await seedIfEmpty(db);
    await seedIfEmpty(db);

    final profiles = await db.allProfiles();
    expect(profiles.map((p) => p.name), ['Mellizas', 'Sobrino']);

    final twins = profiles.first;
    final flat = await db.boardPictograms(twins.id, null);
    expect(flat.length, inInclusiveRange(4, 8));
    expect(flat.first.labelEs, 'quiero agua');
    expect(await db.profileCategories(twins.id), isEmpty);

    final kid = profiles.last;
    final cats = await db.profileCategories(kid.id);
    expect(cats.length, 8);
    final first = await db.boardPictograms(kid.id, cats.first.id);
    expect(first, isNotEmpty);
  });
}
