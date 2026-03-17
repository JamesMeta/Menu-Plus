import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/group_member.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/group_member_list_tile.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/show_ranking_info_dialog.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/show_rating_info_dialog.dart';
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
                Text(
                  "Group Members",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              "Username",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 16.w),

                            Text(
                              "Permission Level",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              "Remove",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        padding:
                            _users.isEmpty
                                ? EdgeInsets.all(8)
                                : EdgeInsets.zero,

                        children:
                            _users
                                .map(
                                  (user) => GroupMemberListTile(
                                    groupMember: user,
                                    deleteTileCallBack: _deleteGroupMember,
                                    modifySecurityLevelCallBack:
                                        _modifyGroupMemberSecurityLevel,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
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
                    IconButton(
                      onPressed: () {
                        if (_userNameController.text.isNotEmpty) {
                          _addNameToGroupMembers(_userNameController.text);
                        }
                      },
                      icon: Icon(Icons.add, color: Colors.white, size: 26.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    _createGroup();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    maximumSize: Size(double.infinity, 50.h),
                    minimumSize: Size(double.infinity, 50.h),
                  ),
                  child: Text(
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
      _users.add(GroupMember(username: name, permissionLevel: 1));
      _userNameController.clear();
    });
  }

  void _deleteGroupMember(GroupMember groupMember) {
    setState(() {
      _users.remove(groupMember);
    });
  }

  void _showRankingInfoDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => ShowRankingInfoDialog());
  }

  void _showRatingInfoDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => ShowRatingInfoDialog());
  }

  void _modifyGroupMemberSecurityLevel(
    GroupMember groupMember,
    int newSecurityLevel,
  ) {
    setState(() {
      groupMember.permissionLevel = newSecurityLevel;
    });
  }

  Future<void> _createGroup() async {
    setState(() {
      _isCreatingGroup = true;
    });

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

    setState(() {
      _isCreatingGroup = false;
    });

    if (response.success) {
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
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create group")));
    }
  }
}
