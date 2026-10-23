import 'package:drift/drift.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get gridSize => integer().withDefault(const Constant(2))();
  BoolColumn get phraseBarEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get nestedCategories =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get nameEs => text()();
  TextColumn get colorHex => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

class Pictograms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get arasaacId => integer().nullable()();
  TextColumn get labelEs => text()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get assetPath => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Posición explícita y fija: nunca se reordena automáticamente (motor planning).
class BoardItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  IntColumn get pictogramId => integer().references(Pictograms, #id)();
  IntColumn get position => integer()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {profileId, categoryId, position},
  ];
}

/// Categorías visibles en un perfil, con orden fijo (previsibilidad).
class ProfileCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get position => integer()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {profileId, categoryId},
  ];
}

/// Rutina o agenda visual de un perfil (ej. "Mañana", "Ir a dormir").
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get name => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Pasos en orden fijo. `done` lo marca el adulto o el chico con el tilde.
class RoutineSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  IntColumn get pictogramId => integer().references(Pictograms, #id)();
  IntColumn get position => integer()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}
