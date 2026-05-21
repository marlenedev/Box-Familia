import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<List<AppUser>> getUsers() async {
    final snapshot =
        await _firestore.collection('users').get();

    return snapshot.docs.map((doc) {
      return AppUser.fromFirestore(
        doc.data(),
        doc.id,
      );
    }).toList();
  }
}