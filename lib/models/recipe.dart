class Recipe {

  final String id;

  final String name;

  final String type;

  final String ownerId;
  final String ownerName;

  Recipe({
    required this.id,
    required this.name,
    required this.type,
    required this.ownerId,
    required this.ownerName,
  });

  factory Recipe.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return Recipe(
      id: id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'savory',
      ownerId: data['ownerId'] ?? '',
      ownerName:
          data['ownerName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'ownerId': ownerId,
      'ownerName': ownerName,
    };
  }
}