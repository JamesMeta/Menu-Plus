import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final image = await _takePhoto();
          if (image != null) {
            await _uploadPhoto(image);
          }
        },
        child: Text("Test"),
      ),
    );
  }

  Future<File?> _takePhoto() async {
    final image = SupabaseHelper.storage.pickImage(ImageSource.camera);
    return image;
  }

  Future<void> _uploadPhoto(File file) async {
    await SupabaseHelper.storage.uploadFileToFolder(
      bucketName: "recipe_image",
      folderName: "2d24a4c0-479f-4656-9778-2e8ab2dce3e6",
      file: file,
      fileName: "test.png",
    );
  }
}
