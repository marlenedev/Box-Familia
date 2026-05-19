abstract class SyncStorage {
  Future<Map<String, dynamic>?> readSnapshot();

  Future<void> writeSnapshot(Map<String, dynamic> snapshot);
}
