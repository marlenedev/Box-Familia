import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import 'home_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  late Future<List<AppUser>> _usersFuture;

  @override
  void initState() {
    super.initState();

    _usersFuture = _firestoreService.getUsers();
  }

  Future<void> _selectUser(AppUser user) async {
    await LocalStorageService.saveUserId(user.id);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qui êtes-vous ?')),
      body: FutureBuilder<List<AppUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  title: Text(
                    user.name,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  onTap: () => _selectUser(user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
