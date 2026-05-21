import 'package:flutter/material.dart';

import '../models/app_user.dart';

import 'devices_tab.dart';
import 'recipes_tab.dart';

class KitchenScreen extends StatelessWidget {
  final AppUser user;

  const KitchenScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuisine')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.kitchen),

              label: const Text('Appareils'),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return DevicesTab(user: user);
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.restaurant),

              label: const Text('Idées recettes'),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return RecipesTab(user: user);
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
