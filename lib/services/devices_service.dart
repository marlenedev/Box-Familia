import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/device.dart';

class DevicesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _collection => _firestore.collection('devices');

  Stream<List<Device>> getDevices() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Device.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addDevice(Device device) async {
    await _collection.add(device.toFirestore());
  }

  Future<void> updateDevice(Device device) async {
    await _collection.doc(device.id).update(device.toFirestore());
  }

  Future<void> deleteDevice(String id) async {
    await _collection.doc(id).delete();
  }
}
