class Tool {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String ownerName;

  Tool({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.ownerName,
  });

  factory Tool.fromFirestore(Map<String, dynamic> data, String id) {
    return Tool(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
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
