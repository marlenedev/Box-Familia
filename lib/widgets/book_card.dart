import 'package:flutter/material.dart';

import '../models/book.dart';

class BookCard extends StatelessWidget {

  final Book book;

  final bool isOwner;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.book,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(8),

      child: ListTile(

        leading: Icon(
          book.type == 'paper'
              ? Icons.menu_book
              : Icons.tablet_mac,
        ),

        title: Text(book.name),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(book.author),

            Text(
              book.type == 'paper'
                  ? 'Livre papier'
                  : 'Livre numérique',
            ),

            Text(
              'Propriétaire : ${book.ownerName}',
            ),
          ],
        ),

        trailing: isOwner
            ? Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                    ),
                    onPressed: onEdit,
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}