import 'package:flutter/material.dart';

class ConfirmDeleteDialog
    extends StatelessWidget {

  final String title;
  final String message;

  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(title),

      content: Text(message),

      actions: [

        TextButton(
          onPressed: () {

            Navigator.pop(context);
          },
          child: const Text(
            'Annuler',
          ),
        ),

        ElevatedButton(
          onPressed: () {

            onConfirm();

            Navigator.pop(context);
          },

          child: const Text(
            'Supprimer',
          ),
        ),
      ],
    );
  }
}