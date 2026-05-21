import 'package:flutter/material.dart';

class BookDialog extends StatelessWidget {

  final TextEditingController nameController;
  final TextEditingController authorController;

  final String selectedType;

  final Function(String?) onTypeChanged;

  final String title;
  final String buttonText;

  final VoidCallback onConfirm;

  const BookDialog({
    super.key,
    required this.nameController,
    required this.authorController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.title,
    required this.buttonText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(title),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                labelText: 'Titre',
              ),
            ),

            TextField(
              controller: authorController,
              decoration:
                  const InputDecoration(
                labelText: 'Auteur',
              ),
            ),

            const SizedBox(height: 16),

            DropdownButton<String>(
              value: selectedType,
              isExpanded: true,
              items: const [

                DropdownMenuItem(
                  value: 'paper',
                  child: Text(
                    'Livre papier',
                  ),
                ),

                DropdownMenuItem(
                  value: 'digital',
                  child: Text(
                    'Livre numérique',
                  ),
                ),
              ],
              onChanged: onTypeChanged,
            ),
          ],
        ),
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