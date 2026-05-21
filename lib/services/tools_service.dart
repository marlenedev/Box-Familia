import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tool.dart';

class ToolsService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference get _toolsCollection =>
      _firestore.collection('tools');

  Stream<List<Tool>> getTools() {

    return _toolsCollection.snapshots().map(
      (snapshot) {

        return snapshot.docs.map((doc) {

          return Tool.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );

        }).toList();
      },
    );
  }

  Future<void> addTool(Tool tool) async {

    await _toolsCollection.add(
      tool.toFirestore(),
    );
  }

  Future<void> updateTool(Tool tool) async {

    await _toolsCollection
        .doc(tool.id)
        .update(
          tool.toFirestore(),
        );
  }

  Future<void> deleteTool(
    String toolId,
  ) async {

    await _toolsCollection
        .doc(toolId)
        .delete();
  }
}