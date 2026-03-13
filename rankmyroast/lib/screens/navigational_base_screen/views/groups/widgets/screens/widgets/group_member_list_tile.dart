import 'package:flutter/material.dart';
import 'package:rankmyroast/models/group_member.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GroupMemberListTile oldWidget) {
    if (oldWidget.groupMember.securityLevel !=
        widget.groupMember.securityLevel) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.groupMember.username),
        Expanded(child: SizedBox()),

        DropdownMenu(
          dropdownMenuEntries:
              securityLevelToRole.entries
                  .map(
                    (entry) =>
                        DropdownMenuEntry(value: entry.key, label: entry.value),
                  )
                  .toList(),
          initialSelection: widget.groupMember.securityLevel,
          onSelected: (value) {
            widget.modifySecurityLevelCallBack(widget.groupMember, value ?? 1);
          },
        ),

        IconButton(
          onPressed: () => widget.deleteTileCallBack(widget.groupMember),
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }
}
