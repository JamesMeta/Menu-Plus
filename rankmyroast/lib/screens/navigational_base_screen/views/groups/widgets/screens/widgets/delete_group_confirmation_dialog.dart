import 'package:flutter/material.dart';

class DeleteGroupConfirmationDialog extends StatelessWidget {
  const DeleteGroupConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Group"),
      content: Text(
        "Are you sure you want to delete this group? This action cannot be undone.",
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Delete", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
