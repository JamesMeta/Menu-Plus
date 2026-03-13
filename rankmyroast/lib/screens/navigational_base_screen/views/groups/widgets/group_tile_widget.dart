import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/models/group.dart';

class GroupTileWidget extends StatelessWidget {
  final Group group;

  const GroupTileWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        group.name,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${group.groupMembers.length} members | ${group.recipes.length} recipes",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black, width: 1),
      ),
      tileColor: Colors.green,
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.more_vert, color: Colors.white, size: 20.sp),
      ),
    );
  }
}
