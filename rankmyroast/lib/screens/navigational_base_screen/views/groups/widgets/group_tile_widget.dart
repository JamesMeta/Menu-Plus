import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rankmyroast/models/group.dart';

class GroupTileWidget extends StatelessWidget {
  final Group group;

  const GroupTileWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.white24,
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
    );
  }
}
