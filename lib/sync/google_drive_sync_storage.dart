import 'sync_storage.dart';

/// Prochaine étape.
///
/// Cette classe est volontairement isolée : le moteur de sync ne dépend pas de
/// Google Drive. Il dépend seulement de l'interface SyncStorage.
///
/// Quand l'authentification Google sera configurée, cette classe devra :
/// 1. Se connecter avec Google Sign-In.
/// 2. Demander le scope Drive appDataFolder.
/// 3. Chercher le fichier JSON de sync dans appDataFolder.
/// 4. Le télécharger / uploader.
///
/// Le reste de l'application ne changera pas.
class GoogleDriveSyncStorage implements SyncStorage {
  @override
  Future<Map<String, dynamic>?> readSnapshot() async {
    throw UnimplementedError(
      'Google Drive sera branché dans la prochaine étape.',
    );
  }

  @override
  Future<void> writeSnapshot(Map<String, dynamic> snapshot) async {
    throw UnimplementedError(
      'Google Drive sera branché dans la prochaine étape.',
    );
  }
}
