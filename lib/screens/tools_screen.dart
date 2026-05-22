import 'package:flutter/material.dart';

import '../models/tool.dart';
import '../models/app_user.dart';

import '../services/tools_service.dart';
import '../widgets/tool_card.dart';
import '../widgets/tool_dialog.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../utils/snackbar_helper.dart';

class ToolsScreen extends StatefulWidget {
  final AppUser user;

  const ToolsScreen({super.key, required this.user});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final ToolsService _toolsService = ToolsService();

  Future<void> _showAddToolDialog() async {
    final nameController = TextEditingController();

    final descriptionController = TextEditingController();

    await showDialog(
      context: context,

      builder: (_) {
        return ToolDialog(
          title: 'Ajouter un outil',

          buttonText: 'Ajouter',

          nameController: nameController,

          descriptionController: descriptionController,

          onConfirm: () async {
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

            final tool = Tool(
              id: '',
              name: name,
              description: description,
              ownerId: widget.user.id,
              ownerName: widget.user.name,
            );

            await _toolsService.addTool(tool);

            if (!mounted) return;

            SnackbarHelper.showSuccess(context, 'Outil ajouté');

            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(Tool tool) async {
    final nameController = TextEditingController(text: tool.name);

    final descriptionController = TextEditingController(text: tool.description);

    await showDialog(
      context: context,

      builder: (_) {
        return ToolDialog(
          title: 'Modifier un outil',

          buttonText: 'Modifier',

          nameController: nameController,

          descriptionController: descriptionController,

          onConfirm: () async {
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

            final updatedTool = Tool(
              id: tool.id,
              name: name,
              description: description,
              ownerId: tool.ownerId,
              ownerName: tool.ownerName,
            );

            await _toolsService.updateTool(updatedTool);

            if (!mounted) return;

            SnackbarHelper.showSuccess(context, 'Outil modifié');

            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bricolage')),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddToolDialog,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Tool>>(
        stream: _toolsService.getTools(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tools = snapshot.data!;

          if (tools.isEmpty) {
            return const Center(child: Text('Aucun outil'));
          }

          return ListView.builder(
            itemCount: tools.length,

            itemBuilder: (context, index) {
              final tool = tools[index];

              final isOwner = tool.ownerId == widget.user.id;

              return ToolCard(
                tool: tool,
                isOwner: isOwner,

                onEdit: () {
                  _showEditDialog(tool);
                },

                onDelete: () async {
                  showDialog(
                    context: context,

                    builder: (_) {
                      return ConfirmDeleteDialog(
                        title: "Suppression de l'outil : ${tool.name}",

                        message: 'Voulez-vous supprimer cet outil ?',

                        onConfirm: () async {
                          await _toolsService.deleteTool(tool.id);
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
