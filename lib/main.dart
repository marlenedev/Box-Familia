import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/user_selection_screen.dart';
import 'screens/home_screen.dart';

import 'services/local_storage_service.dart';
import 'services/firestore_service.dart';

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final userId = await LocalStorageService.getUserId();

    if (userId == null) {
      return const UserSelectionScreen();
    }

    final users = await FirestoreService().getUsers();

    final user = users.firstWhere((u) => u.id == userId);

    return HomeScreen(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Inventory',
      theme: AppTheme.themeData,
      home: FutureBuilder(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data!;
        },
      ),
    );
  }
}
