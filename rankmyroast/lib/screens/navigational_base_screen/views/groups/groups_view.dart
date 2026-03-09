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

  double _yOffset = 0;

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
                return Text(
                  "No active groups found.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
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
                  children: [
                    Text(
                      "Create your first group.",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: createGroup,
                      child: Text("Create Group"),
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
                          return GroupTileWidget(group: snapshot.data![index]);
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

  void createGroup() {
    context.push("/base/create-group");
  }

  Future<List<Group>> _fetchGroups() async {
    final groups = await SupabaseHelper.getGroupsForUser();

    if (groups == null) {
      return [];
    }

    return groups;
  }
}
