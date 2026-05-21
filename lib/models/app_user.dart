class AppUser {
  final String id;
  final String name;

  AppUser({required this.id, required this.name});

  factory AppUser.fromFirestore(Map<String, dynamic> data, String id) {
    return AppUser(id: id, name: data['name'] ?? '');
  }
}
