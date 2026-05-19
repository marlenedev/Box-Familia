import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../db/app_database.dart';
import '../domain/user_form_data.dart';

class UserRepository {
  UserRepository(this._db, {required this.deviceId});

  final AppDatabase _db;
  final String deviceId;
  final Uuid _uuid = const Uuid();

  Stream<List<Utilisateur>> watchActiveUsers() {
    return (_db.select(_db.utilisateurs)
          ..where((u) => u.deletedAt.isNull())
          ..orderBy([
            (u) => OrderingTerm.asc(u.nom),
            (u) => OrderingTerm.asc(u.prenom),
          ]))
        .watch();
  }

  Future<List<Utilisateur>> getUsersToSync() {
    return (_db.select(
      _db.utilisateurs,
    )..where((u) => u.needsSync.equals(true))).get();
  }

  Future<void> createUser(UserFormData form) async {
    final now = DateTime.now().toUtc();

    await _db
        .into(_db.utilisateurs)
        .insert(
          UtilisateursCompanion.insert(
            id: _uuid.v4(),
            nom: form.nom.trim(),
            prenom: form.prenom.trim(),
            email: Value(_normalizeNullable(form.email)),
            telephone: Value(_normalizeNullable(form.telephone)),
            createdAt: now,
            updatedAt: now,
            deviceId: deviceId,
          ),
        );
  }

  Future<void> updateUser(Utilisateur user, UserFormData form) async {
    final now = DateTime.now().toUtc();

    await (_db.update(
      _db.utilisateurs,
    )..where((u) => u.id.equals(user.id))).write(
      UtilisateursCompanion(
        nom: Value(form.nom.trim()),
        prenom: Value(form.prenom.trim()),
        email: Value(_normalizeNullable(form.email)),
        telephone: Value(_normalizeNullable(form.telephone)),
        updatedAt: Value(now),
        version: Value(user.version + 1),
        deviceId: Value(deviceId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> softDeleteUser(Utilisateur user) async {
    final now = DateTime.now().toUtc();

    await (_db.update(
      _db.utilisateurs,
    )..where((u) => u.id.equals(user.id))).write(
      UtilisateursCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        version: Value(user.version + 1),
        deviceId: Value(deviceId),
        needsSync: const Value(true),
      ),
    );
  }

  Future<void> markAllAsSynced() async {
    await (_db.update(_db.utilisateurs)..where((u) => u.needsSync.equals(true)))
        .write(const UtilisateursCompanion(needsSync: Value(false)));
  }

  Future<void> upsertFromSync(Utilisateur remoteUser) async {
    final local = await (_db.select(
      _db.utilisateurs,
    )..where((u) => u.id.equals(remoteUser.id))).getSingleOrNull();

    if (local == null) {
      await _db
          .into(_db.utilisateurs)
          .insert(remoteUser.copyWith(needsSync: false));
      return;
    }

    // MVP : Last Write Wins.
    // La ligne la plus récente gagne. Plus tard, on pourra remplacer cette règle
    // par une fusion champ par champ avec écran de résolution de conflits.
    if (remoteUser.updatedAt.isAfter(local.updatedAt)) {
      await _db
          .update(_db.utilisateurs)
          .replace(remoteUser.copyWith(needsSync: false));
    }
  }

  String? _normalizeNullable(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
