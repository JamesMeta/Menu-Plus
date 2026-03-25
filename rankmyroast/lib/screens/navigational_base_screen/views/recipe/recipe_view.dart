import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/recipe.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool groupRecipes = true;

  late final Future<List<Group>?> _groupsList;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            FutureBuilder(
              future: _groupsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  final groups = snapshot.data;

                  if (groups != null) {
                    return DropdownMenu(
                      dropdownMenuEntries:
                          groups
                              .map(
                                (group) => DropdownMenuEntry(
                                  value: group,
                                  label: group.name,
                                ),
                              )
                              .toList(),
                    );
                  } else {
                    return Center(child: Text("The Data is null"));
                  }
                } else {
                  return Center(child: Text("The Data is never coming"));
                }
              },
            ),
          ],
        ),

        SizedBox(height: 8.h),

        FutureBuilder(
          future: _groupsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              final groups = snapshot.data;

              if (groups != null) {
                return Center(child: Text("Data has arrived"));
              } else {
                return Center(child: Text("The Data is null"));
              }
            } else {
              return Center(child: Text("The Data is never coming"));
            }
          },
        ),
      ],
    );
  }

  Future<void> _loadData() async {
    _groupsList = SupabaseHelper.groups.getGroupsForUser();
  }

  // Future<File?> _takePhoto() async {
  //   final image = SupabaseHelper.storage.pickImage(ImageSource.camera);
  //   return image;
  // }

  // Future<void> _uploadPhoto(File file) async {
  //   await SupabaseHelper.storage.uploadFileToFolder(
  //     bucketName: "recipe_image",
  //     folderName: "2d24a4c0-479f-4656-9778-2e8ab2dce3e6",
  //     file: file,
  //     fileName: "test.png",
  //   );
  // }
}
