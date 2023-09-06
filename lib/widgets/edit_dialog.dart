import 'package:flutter/material.dart';
import 'package:taskmaster/models/item.dart';

class EditDialog extends StatefulWidget {
  const EditDialog(this.item,
      {super.key, required this.onItemDelete, required this.onItemSave});

  final Item item;
  final void Function(Item item) onItemDelete;
  final void Function(Item item) onItemSave;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = widget.item.name;

    return AlertDialog(
      title: const Text('Edit'),
      content: TextField(
        controller: textController,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            widget.onItemDelete(widget.item);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            widget.item.name = textController.text;
            widget.onItemSave(widget.item);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
