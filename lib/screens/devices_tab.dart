import 'package:flutter/material.dart';

import '../models/device.dart';
import '../models/app_user.dart';

import '../services/devices_service.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../utils/snackbar_helper.dart';

class DevicesTab extends StatefulWidget {
  final AppUser user;

  const DevicesTab({super.key, required this.user});

  @override
  State<DevicesTab> createState() => _DevicesTabState();
}

class _DevicesTabState extends State<DevicesTab> {
  final DevicesService _service = DevicesService();

  Future<void> _showAddDialog() async {
    final nameController = TextEditingController();

    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Ajouter'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  contentPadding: EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),

            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();

                final description = descriptionController.text.trim();

                if (name.isEmpty) {
                  SnackbarHelper.showError(context, 'Le nom est obligatoire');

                  return;
                }

                if (description.isEmpty) {
                  SnackbarHelper.showError(
                    context,
                    'La description est obligatoire',
                  );

                  return;
                }

                final device = Device(
                  id: '',
                  name: name,
                  description: description,
                  ownerId: widget.user.id,
                  ownerName: widget.user.name,
                );

                await _service.addDevice(device);

                if (!mounted) return;

                SnackbarHelper.showSuccess(context, 'Appareil ajouté');

                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(Device device) async {
    final nameController = TextEditingController(text: device.name);

    final descriptionController = TextEditingController(
      text: device.description,
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Modifier appareil'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),

            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();

                final description = descriptionController.text.trim();

                if (name.isEmpty) {
                  SnackbarHelper.showError(context, 'Le nom est obligatoire');

                  return;
                }

                if (description.isEmpty) {
                  SnackbarHelper.showError(
                    context,
                    'La description est obligatoire',
                  );

                  return;
                }
                final updatedDevice = Device(
                  id: device.id,
                  name: name,
                  description: description,
                  ownerId: device.ownerId,
                  ownerName: device.ownerName,
                );

                await _service.updateDevice(updatedDevice);

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appareils')),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Device>>(
        stream: _service.getDevices(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!;

          if (devices.isEmpty) {
            return const Center(child: Text('Aucun appareil'));
          }

          return ListView.builder(
            itemCount: devices.length,

            itemBuilder: (context, index) {
              final device = devices[index];

              final isOwner = device.ownerId == widget.user.id;

              return Card(
                margin: const EdgeInsets.all(8),

                child: ListTile(
                  leading: const Icon(Icons.kitchen),

                  title: Text(device.name),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.description),

                      Text('Propriétaire : ${device.ownerName}'),
                    ],
                  ),

                  trailing: isOwner
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(device);
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,

                                  builder: (_) {
                                    return ConfirmDeleteDialog(
                                      title: 'Suppression de : ${device.name}',

                                      message:
                                          'Voulez-vous supprimer cet appareil ?',

                                      onConfirm: () async {
                                        await _service.deleteDevice(device.id);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
