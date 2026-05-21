class Book {

  final String id;

  final String name;
  final String author;

  final String type;

  final String ownerId;
  final String ownerName;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.type,
    required this.ownerId,
    required this.ownerName,
  });

  factory Book.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return Book(
      id: id,
      name: data['name'] ?? '',
      author: data['author'] ?? '',
      type: data['type'] ?? 'paper',
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'author': author,
      'type': type,
      'ownerId': ownerId,
      'ownerName': ownerName,
    };
  }
}