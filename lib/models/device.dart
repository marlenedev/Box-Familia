class Device {

  final String id;

  final String name;
  final String description;

  final String ownerId;
  final String ownerName;

  Device({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.ownerName,
  });

  factory Device.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return Device(
      id: id,
      name: data['name'] ?? '',
      description:
          data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerName:
          data['ownerName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'ownerName': ownerName,
    };
  }
}