import 'package:flutter/material.dart';

import '../models/tool.dart';

class ToolCard extends StatelessWidget {

  final Tool tool;
  final bool isOwner;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ToolCard({
    super.key,
    required this.tool,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(8),

      child: ListTile(

        title: Text(tool.name),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(tool.description),

            Text(
              'Propriétaire : ${tool.ownerName}',
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