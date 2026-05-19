import '../features/users/data/user_repository.dart';
import 'sync_change.dart';
import 'sync_storage.dart';

class SyncService {
  SyncService({
    required UserRepository userRepository,
    required SyncStorage storage,
  }) : _userRepository = userRepository,
       _storage = storage;

  final UserRepository _userRepository;
  final SyncStorage _storage;

  Future<SyncResult> synchronize() async {
    final remoteJson = await _storage.readSnapshot();

    if (remoteJson != null) {
      final remoteSnapshot = SyncSnapshot.fromJson(remoteJson);
      for (final remoteUser in remoteSnapshot.utilisateurs) {
        await _userRepository.upsertFromSync(remoteUser);
      }
    }

    final usersToPublish = await _userRepository.getUsersToSync();
    final snapshot = SyncSnapshot(utilisateurs: usersToPublish);
    await _storage.writeSnapshot(snapshot.toJson());
    await _userRepository.markAllAsSynced();

    return SyncResult(
      uploadedUsers: usersToPublish.length,
      downloadedSnapshotFound: remoteJson != null,
    );
  }
}

class SyncResult {
  const SyncResult({
    required this.uploadedUsers,
    required this.downloadedSnapshotFound,
  });

  final int uploadedUsers;
  final bool downloadedSnapshotFound;
}
