import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/group_tile_widget.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class GroupsView extends StatefulWidget {
  const GroupsView({super.key});

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  late Future<List<Group>> _groups;

  @override
  void initState() {
    _groups = _fetchGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: _groups,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  children: [
                    Text(
                      "Active Groups ",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(0)",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: createGroup,
                      icon: Icon(Icons.add, color: Colors.white, size: 22.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox();
              } else {
                return Row(
                  children: [
                    Text(
                      "Active Groups ",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${snapshot.data!.length})",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: createGroup,
                      icon: Icon(Icons.add, color: Colors.white, size: 22.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 16.h),
          FutureBuilder(
            future: _groups,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 220.h),
                    Center(
                      child: Text(
                        "Create your first group.",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: createGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        maximumSize: Size(100.w, 40.h),
                        minimumSize: Size(100.w, 40.h),
                      ),
                      child: Text(
                        "Create Group",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              } else {
                return Expanded(
                  child: SizedBox(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _groups = _fetchGroups();
                        });
                      },
                      color: Colors.white, // Color of the spinner
                      backgroundColor:
                          Colors.green, // Background of the spinner circle

                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GroupTileWidget(
                            group: snapshot.data![index],
                            editGroupCallback: editGroupCallback,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void createGroup() async {
    final refresh = await context.push("/base/create-group");

    if (refresh == true) {
      setState(() {
        _groups = _fetchGroups();
      });
    }
  }

  void editGroupCallback() {
    setState(() {
      _groups = _fetchGroups();
    });
  }

  Future<List<Group>> _fetchGroups() async {
    final groups = await SupabaseHelper.groups.getGroupsForUser();

    if (groups == null) {
      return [];
    }

    return groups;
  }
}
