import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'sync_storage.dart';

/// Stockage local temporaire pour tester le moteur de synchronisation sans Google.
/// À remplacer ensuite par GoogleDriveSyncStorage.
class LocalFileSyncStorage implements SyncStorage {
  const LocalFileSyncStorage();

  static const String fileName = 'box_familia_sync_snapshot.json';

  @override
  Future<Map<String, dynamic>?> readSnapshot() async {
    final file = await _snapshotFile();
    if (!await file.exists()) return null;

    final content = await file.readAsString();
    if (content.trim().isEmpty) return null;

    return jsonDecode(content) as Map<String, dynamic>;
  }

  @override
  Future<void> writeSnapshot(Map<String, dynamic> snapshot) async {
    final file = await _snapshotFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(snapshot),
    );
  }

  Future<File> _snapshotFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, fileName));
  }
}
