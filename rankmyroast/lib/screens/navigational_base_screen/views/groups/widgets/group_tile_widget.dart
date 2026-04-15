import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/classes/modals/group.dart';

class GroupTileWidget extends StatelessWidget {
  final Group group;
  final VoidCallback? editGroupCallback;

  const GroupTileWidget({
    super.key,
    required this.group,
    this.editGroupCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
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
          onPressed: () async {
            final refresh = await context.push(
              '/base/create-group',
              extra: group,
            );
            if (refresh == true && editGroupCallback != null) {
              editGroupCallback!();
            }
          },
          icon: Icon(Icons.edit, color: Colors.white, size: 20.sp),
        ),
      ),
    );
  }
}
