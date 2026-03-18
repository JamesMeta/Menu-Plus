import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/group_member.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/group_member_list_tile.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/group_security_informational_dialog.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  final List<GroupMember> _users = [];

  bool _isCreatingGroup = false;
  bool _isUsingRating = false;
  bool _showRatings = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,

        foregroundColor: Colors.white,
        title: Text(
          "Create Group",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Group Name",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _groupNameController,

                    decoration: InputDecoration(
                      labelText: "Enter group name",
                      labelStyle: TextStyle(fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.never,

                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  "Group Settings",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text("Show Rankings"),
                        activeColor: Colors.green,
                        subtitle: Text(
                          "Display recipe rankings to group members",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        value: _showRatings,
                        onChanged: (value) {
                          setState(() {
                            _showRatings = value;
                          });
                        },
                      ),

                      SwitchListTile(
                        title: Text("Use Ratings"),
                        activeColor: Colors.green,
                        subtitle: Text(
                          "Use a rating system instead of a ranking system",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        value: _isUsingRating,
                        onChanged: (value) {
                          setState(() {
                            _isUsingRating = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Group Members",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showGroupSecurityInformationalDialog(),
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.info_outline),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.bottomCenter,
                      iconSize: 20.sp,
                      constraints: BoxConstraints(),
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _users.isEmpty
                    ? SizedBox()
                    : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Valid",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    "Username",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    "Permissions",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Expanded(flex: 3, child: SizedBox()),
                              ],
                            ),
                          ),
                          Divider(color: Colors.black, height: 1),
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 20.h,
                              maxHeight: 150.h,
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,

                              children:
                                  _users
                                      .map(
                                        (user) => GroupMemberListTile(
                                          groupMember: user,
                                          deleteTileCallBack:
                                              _deleteGroupMember,
                                          modifySecurityLevelCallBack:
                                              _modifyGroupMemberSecurityLevel,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                _users.isEmpty ? SizedBox() : SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      flex: 17,
                      child: Container(
                        height: 42.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _userNameController,

                          decoration: InputDecoration(
                            labelText: "Add member by username",
                            labelStyle: TextStyle(fontSize: 18),
                            floatingLabelBehavior: FloatingLabelBehavior.never,

                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: IconButton(
                        padding: EdgeInsets.zero,

                        onPressed: () {
                          if (_userNameController.text.isNotEmpty) {
                            _addNameToGroupMembers(_userNameController.text);
                          }
                        },
                        icon: Icon(Icons.add, color: Colors.white),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 42.h),

                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            side: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_isCreatingGroup) return;
                    setState(() {
                      _isCreatingGroup = true;
                    });
                    final response = await _createGroup();
                    setState(() {
                      _isCreatingGroup = false;
                    });

                    if (response == true && context.mounted) {
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    maximumSize: Size(double.infinity, 50.h),
                    minimumSize: Size(double.infinity, 50.h),
                  ),
                  child:
                      _isCreatingGroup
                          ? CircularProgressIndicator()
                          : Text(
                            "Create Group",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNameToGroupMembers(String name) {
    setState(() {
      _users.add(GroupMember(username: name, permissionLevel: 2));
      _userNameController.clear();
    });
  }

  void _deleteGroupMember(GroupMember groupMember) {
    setState(() {
      _users.remove(groupMember);
    });
  }

  void _modifyGroupMemberSecurityLevel(
    GroupMember groupMember,
    int newSecurityLevel,
  ) {
    setState(() {
      groupMember.permissionLevel = newSecurityLevel;
    });
  }

  void _showGroupSecurityInformationalDialog() {
    showDialog(
      context: context,
      builder: (context) => GroupSecurityInformationalDialog(),
    );
  }

  Future<bool?> _createGroup() async {
    if (_groupNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Group name cannot be empty")));
      return false;
    }

    if (_groupNameController.text.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Group name cannot be longer than 20 characters"),
        ),
      );
      return false;
    }

    final group = Group(
      id: "NA",
      createdAt: "NA",
      name: _groupNameController.text,
      gradeVisible: _showRatings,
      useRating: _isUsingRating,
      isPersonalGroup: false,
      userId: SupabaseHelper.users.getAuthId(),
      groupMembers: _users,
      recipes: [],
    );

    final response = await SupabaseHelper.groups.createGroup(group);

    if (response.success && mounted) {
      final failedMembers = response.failedToAddMembers;

      if (failedMembers != null) {
        for (var failedMember in failedMembers) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add ${failedMember.username}")),
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Group '${_groupNameController.text}' created!"),
        ),
      );

      if (response.failedToAddMembers != null) {
        final failedMembers = response.failedToAddMembers!;
        if (failedMembers.isNotEmpty) {
          for (var failedMember in failedMembers) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to add ${failedMember.username}")),
            );
          }
        }
      }
      return true;
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to create group")));
      }
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }
}
