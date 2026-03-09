import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/show_ranking_info_dialog.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/widgets/screens/widgets/show_rating_info_dialog.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  final users = [
    "John Doe",
    "Jane Smith",
    "Alice Johnson",
    "Bob Brown",
    "Charlie Davis",
  ];

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
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: "Group Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              Container(
                width: 100,
                height: 100,
                child: Row(
                  children: [
                    SwitchListTile(
                      title: Text("Show Rankings"),
                      value: _showRatings,
                      onChanged: (value) {
                        setState(() {
                          _isUsingRating = value;
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _showRankingInfoDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              Container(
                width: 100,
                height: 100,
                child: Row(
                  children: [
                    SwitchListTile(
                      title: Text("Use Ratings"),
                      value: _isUsingRating,
                      onChanged: (value) {
                        setState(() {
                          _isUsingRating = value;
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _showRatingInfoDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                children:
                    users
                        .map(
                          (user) => CheckboxListTile(
                            title: Text(user),
                            value: false,
                            onChanged: (value) {
                              // Handle user selection
                            },
                          ),
                        )
                        .toList(),
              ),

              ElevatedButton(
                onPressed: () {
                  //TODO
                },
                child: Text("Create Group"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRankingInfoDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => ShowRankingInfoDialog());
  }

  void _showRatingInfoDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => ShowRatingInfoDialog());
  }
}
