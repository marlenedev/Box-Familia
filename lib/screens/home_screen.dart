import 'package:flutter/material.dart';

import '../models/app_user.dart';

import '../services/local_storage_service.dart';

import 'user_selection_screen.dart';
import 'tools_screen.dart';
import 'books_screen.dart';
import 'kitchen_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  Future<void> _changeUser(
    BuildContext context,
  ) async {

    await LocalStorageService.clearUserId();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const UserSelectionScreen(),
      ),
      (route) => false,
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(
          icon,
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bonjour ${user.name}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _changeUser(context),
          ),
        ],
      ),
      body: ListView(
        children: [

          const SizedBox(height: 20),

          _buildCard(
            context: context,
            title: 'Bricolage',
            icon: Icons.handyman,
            screen: ToolsScreen(user: user),
          ),

          _buildCard(
            context: context,
            title: 'Cuisine',
            icon: Icons.kitchen,
            screen: KitchenScreen(user: user),
          ),

          _buildCard(
            context: context,
            title: 'Livres',
            icon: Icons.menu_book,
            screen: BooksScreen(user: user),
          ),
        ],
      ),
    );
  }
}