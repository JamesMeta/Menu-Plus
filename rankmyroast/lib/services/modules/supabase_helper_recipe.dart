import 'dart:io';

import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/responses/create_recipe_response.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelperRecipe {
  static final _client = Supabase.instance.client;

  Future<CreateRecipeResponse> createNewRecipe(
    File? image,
    String name,
    List<String>? ingredientList,
    List<String>? instructionList,
    List<String>? groceryList,
    List<Group> groupList,
    bool? isPublic,
  ) async {
    try {
      final response =
          await _client
              .from("recipe")
              .insert({
                "name": name,
                "ingredients": ingredientList,
                "instructions": instructionList,
                "groceries": groceryList,
                "is_public": isPublic,
              })
              .select("*")
              .single();

      final recipeId = response["id"];
      final imageName = response["image_name"];

      if (imageName == null) {
        return CreateRecipeResponse(
          success: false,
          localError: true,
          errorMessage:
              "Error: Recipe failed to be created at this time, please try again later.",
        );
      }

      final success = true;

      final List<Map<String, dynamic>> groupLinks =
          groupList
              .map((g) => {"recipe_id": recipeId, "group_id": g.id})
              .toList();

      final failedGroups = <Group>[];

      try {
        await _client.from("recipe_group").insert(groupLinks);
      } catch (e) {
        failedGroups.addAll(groupList);
      }

      bool imageUploadFailed = false;
      if (image != null) {
        final imageResponse = await SupabaseHelper.storage.uploadFileToBucket(
          bucketName: "public_recipe_image",
          file: image,
          fileName: imageName,
        );

        if (imageResponse == null) imageUploadFailed = true;
      }
      return CreateRecipeResponse(
        success: success,
        failedToAddGroups: failedGroups,
        failedToUploadImage: imageUploadFailed,
      );
    } catch (e) {
      return CreateRecipeResponse(
        success: false,
        localError: false,
        errorMessage: e.toString(),
      );
    }
  }
}
