import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/models/group_member.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class GroupMemberListTile extends StatefulWidget {
  final GroupMember groupMember;
  final void Function(GroupMember groupMember) deleteTileCallBack;
  final void Function(GroupMember groupMember, int newSecurityLevel)
  modifySecurityLevelCallBack;

  const GroupMemberListTile({
    super.key,
    required this.groupMember,
    required this.deleteTileCallBack,
    required this.modifySecurityLevelCallBack,
  });

  @override
  State<GroupMemberListTile> createState() => _GroupMemberListTileState();
}

class _GroupMemberListTileState extends State<GroupMemberListTile> {
  Map<int, String> securityLevelToRole = {
    1: "Read Only",
    2: "Read & Write",
    3: "Read, Write & Modify",
  };

  late Future<bool> isValid;

  @override
  void initState() {
    super.initState();
    isValid = _isUsernameReal();
  }

  @override
  void didUpdateWidget(covariant GroupMemberListTile oldWidget) {
    if (oldWidget.groupMember.permissionLevel !=
        widget.groupMember.permissionLevel) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      child: Row(
        children: [
          FutureBuilder(
            future: isValid,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.error != null) {
                return Icon(Icons.dangerous_outlined);
              } else {
                if (snapshot.data == true) {
                  return Icon(Icons.check_box);
                } else {
                  return Icon(Icons.dangerous_outlined);
                }
              }
            },
          ),
          Text(widget.groupMember.username),
          Expanded(child: SizedBox()),

          DropdownMenu(
            width: 195.w,
            textStyle: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            dropdownMenuEntries:
                securityLevelToRole.entries
                    .map(
                      (entry) => DropdownMenuEntry(
                        value: entry.key,
                        label: entry.value,
                      ),
                    )
                    .toList(),
            initialSelection: widget.groupMember.permissionLevel,
            onSelected: (value) {
              widget.modifySecurityLevelCallBack(
                widget.groupMember,
                value ?? 1,
              );
            },
          ),

          IconButton(
            onPressed: () => widget.deleteTileCallBack(widget.groupMember),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<bool> _isUsernameReal() async {
    return !await SupabaseHelper.users.checkUsernameUniqueness(
      widget.groupMember.username,
    );
  }
}
