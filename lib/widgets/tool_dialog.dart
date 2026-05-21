import 'package:flutter/material.dart';

class ToolDialog extends StatelessWidget {

  final TextEditingController nameController;

  final TextEditingController
      descriptionController;

  final String title;
  final String buttonText;

  final VoidCallback onConfirm;

  const ToolDialog({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.title,
    required this.buttonText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(title),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nom',
            ),
          ),

          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
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
          onPressed: onConfirm,
          child: Text(buttonText),
        ),
      ],
    );
  }
}