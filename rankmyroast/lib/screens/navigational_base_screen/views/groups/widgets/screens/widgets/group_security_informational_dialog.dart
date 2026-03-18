import 'package:flutter/material.dart';

class GroupSecurityInformationalDialog extends StatelessWidget {
  const GroupSecurityInformationalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Group Security Levels"),
      actionsAlignment: MainAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Read Only: Can view group recipes but can not rank them or add new ones.",
          ),
          SizedBox(height: 8),
          Text(
            "Read & Write: Can view, rank and create new group recipes but cannot modify existing ones or change group settings and users.",
          ),
          SizedBox(height: 8),
          Text(
            "Admin: Full access to view, modify, and manage group data, settings and members.",
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Got it!"),
        ),
      ],
    );
  }
}
