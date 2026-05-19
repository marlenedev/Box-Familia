import 'package:flutter/material.dart';

import '../db/app_database.dart';
import '../features/users/data/user_repository.dart';
import '../features/users/domain/user_form_data.dart';
import '../sync/local_file_sync_storage.dart';
import '../sync/sync_service.dart';

class BoxFamiliaApp extends StatefulWidget {
  const BoxFamiliaApp({super.key});

  @override
  State<BoxFamiliaApp> createState() => _BoxFamiliaAppState();
}

class _BoxFamiliaAppState extends State<BoxFamiliaApp> {
  late final AppDatabase _db;
  late final UserRepository _userRepository;
  late final SyncService _syncService;

  String _syncStatus = 'Synchronisation non lancée';

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _userRepository = UserRepository(_db, deviceId: 'local-device-dev');
    _syncService = SyncService(
      userRepository: _userRepository,
      storage: const LocalFileSyncStorage(),
    );
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Box Familia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Box Familia')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_syncStatus),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _synchronize,
                  icon: const Icon(Icons.sync),
                  label: const Text('Synchroniser'),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: StreamBuilder<List<Utilisateur>>(
                    stream: _userRepository.watchActiveUsers(),
                    builder: (context, snapshot) {
                      final users = snapshot.data ?? const <Utilisateur>[];

                      if (users.isEmpty) {
                        return const Center(
                          child: Text('Aucun utilisateur pour le moment.'),
                        );
                      }

                      return ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            title: Text('${user.prenom} ${user.nom}'),
                            subtitle: Text(user.email ?? 'Aucun email'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  _userRepository.softDeleteUser(user),
                            ),
                            onTap: () => _openUserForm(user: user),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openUserForm(),
          icon: const Icon(Icons.add),
          label: const Text('Utilisateur'),
        ),
      ),
    );
  }

  Future<void> _synchronize() async {
    setState(() => _syncStatus = 'Synchronisation en cours...');

    try {
      final result = await _syncService.synchronize();
      setState(() {
        _syncStatus =
            'Sync OK : ${result.uploadedUsers} utilisateur(s) envoyé(s).';
      });
    } catch (e) {
      setState(() => _syncStatus = 'Erreur de synchronisation : $e');
    }
  }

  Future<void> _openUserForm({Utilisateur? user}) async {
    final result = await showDialog<UserFormData>(
      context: context,
      builder: (context) => _UserFormDialog(user: user),
    );

    if (result == null) return;

    if (user == null) {
      await _userRepository.createUser(result);
    } else {
      await _userRepository.updateUser(user, result);
    }
  }
}

class _UserFormDialog extends StatefulWidget {
  const _UserFormDialog({this.user});

  final Utilisateur? user;

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _emailController;
  late final TextEditingController _telephoneController;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nomController = TextEditingController(text: user?.nom ?? '');
    _prenomController = TextEditingController(text: user?.prenom ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _telephoneController = TextEditingController(text: user?.telephone ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.user == null
            ? 'Ajouter un utilisateur'
            : 'Modifier un utilisateur',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                textCapitalization: TextCapitalization.words,
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                textCapitalization: TextCapitalization.words,
                validator: _requiredValidator,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Enregistrer')),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      UserFormData(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        telephone: _telephoneController.text,
      ),
    );
  }
}
