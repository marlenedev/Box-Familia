import 'package:flutter/material.dart';

import '../models/app_user.dart';

import '../services/local_storage_service.dart';

import 'user_selection_screen.dart';
import 'tools_screen.dart';
import 'books_screen.dart';
import 'kitchen_screen.dart';
import '../widgets/home_category_card.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;

  const HomeScreen({super.key, required this.user});

  Future<void> _changeUser(BuildContext context) async {
    await LocalStorageService.clearUserId();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const UserSelectionScreen()),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Familia Box'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _changeUser(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            const SizedBox(height: 8),

            Text(
              'Bonjour ${user.name} 👋',

              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Que souhaitez-vous consulter ?',

              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            const SizedBox(height: 32),

            HomeCategoryCard(
              title: 'Bricolage',

              subtitle: 'Outils partagés',

              icon: Icons.handyman,

              color: AppTheme.darkGreen,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ToolsScreen(user: user);
                    },
                  ),
                );
              },
            ),

            HomeCategoryCard(
              title: 'Livres',

              subtitle: 'Papier & numérique',

              icon: Icons.menu_book,

              color: AppTheme.orange,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return BooksScreen(user: user);
                    },
                  ),
                );
              },
            ),

            HomeCategoryCard(
              title: 'Cuisine',

              subtitle: 'Idées recettes & appareils',

              icon: Icons.restaurant,

              color: AppTheme.green,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return KitchenScreen(user: user);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
