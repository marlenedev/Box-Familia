import 'package:flutter/material.dart';

import '../models/tool.dart';
import '../models/app_user.dart';

import '../services/tools_service.dart';
import '../widgets/tool_card.dart';
import '../widgets/tool_dialog.dart';

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
            final tool = Tool(
              id: '',
              name: nameController.text,
              description: descriptionController.text,
              ownerId: widget.user.id,
              ownerName: widget.user.name,
            );

            await _toolsService.addTool(tool);

            if (!mounted) return;

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
          title: 'Ajouter un outil',
          buttonText: 'Ajouter',
          nameController: nameController,
          descriptionController: descriptionController,
          onConfirm: () async {
            final tool = Tool(
              id: '',
              name: nameController.text,
              description: descriptionController.text,
              ownerId: widget.user.id,
              ownerName: widget.user.name,
            );

            await _toolsService.addTool(tool);

            if (!mounted) return;

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
                  await _toolsService.deleteTool(tool.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
