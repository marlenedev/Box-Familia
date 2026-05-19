import '../db/app_database.dart';

class SyncSnapshot {
  const SyncSnapshot({required this.utilisateurs});

  final List<Utilisateur> utilisateurs;

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': 1,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'utilisateurs': utilisateurs.map(_userToJson).toList(),
    };
  }

  static SyncSnapshot fromJson(Map<String, dynamic> json) {
    final usersJson = (json['utilisateurs'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return SyncSnapshot(utilisateurs: usersJson.map(_userFromJson).toList());
  }

  static Map<String, dynamic> _userToJson(Utilisateur user) {
    return {
      'id': user.id,
      'nom': user.nom,
      'prenom': user.prenom,
      'email': user.email,
      'telephone': user.telephone,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
      'deletedAt': user.deletedAt?.toIso8601String(),
      'version': user.version,
      'deviceId': user.deviceId,
    };
  }

  static Utilisateur _userFromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String).toUtc(),
      version: json['version'] as int,
      deviceId: json['deviceId'] as String,
      needsSync: false,
    );
  }
}
