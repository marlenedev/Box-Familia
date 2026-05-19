import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('Utilisateur')
class Utilisateurs extends Table {
  TextColumn get id => text()();

  TextColumn get nom => text().withLength(min: 1, max: 120)();

  TextColumn get prenom => text().withLength(min: 1, max: 120)();

  TextColumn get email => text().nullable()();

  TextColumn get telephone => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Suppression logique obligatoire pour une future synchronisation multi-appareils.
  /// Une suppression physique empêcherait les autres appareils de savoir qu'il faut
  /// supprimer la ligne chez eux.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Version métier de la ligne. Elle augmente à chaque modification locale.
  IntColumn get version => integer().withDefault(const Constant(1))();

  /// Identifiant stable de l'appareil ayant modifié la ligne.
  TextColumn get deviceId => text()();

  /// Indique si la ligne doit être envoyée pendant la prochaine synchronisation.
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Utilisateurs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'box_familia.sqlite');
  }
}
