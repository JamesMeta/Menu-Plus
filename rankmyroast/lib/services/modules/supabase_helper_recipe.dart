import 'dart:io';

import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/responses/create_recipe_response.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

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
      final insert =
          image == null
              ? {
                "name": name,
                "ingredients": ingredientList,
                "instructions": instructionList,
                "groceries": groceryList,
                "is_public": isPublic,
                "image_name": null,
              }
              : {
                "name": name,
                "ingredients": ingredientList,
                "instructions": instructionList,
                "groceries": groceryList,
                "is_public": isPublic,
              };

      final response =
          await _client.from("recipe").insert(insert).select("*").single();

      final recipeId = response["id"];
      final imageName = response["image_name"];

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

      bool imageUploadFailed = true;
      if (image != null) {
        final imageResponse = await SupabaseHelper.storage.uploadFileToBucket(
          bucketName: "public_recipe_image",
          file: image,
          fileName: imageName,
        );

        if (imageResponse != null) imageUploadFailed = false;
      } else {
        imageUploadFailed = false;
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

  String generateUUID() {
    final uuid = Uuid();

    return uuid.v4();
  }

  Future<CreateRecipeResponse> updateRecipe(
    File? image,
    String name,
    List<String>? ingredientList,
    List<String>? instructionList,
    List<String>? groceryList,
    List<Group> groupList,
    bool? isPublic,
    bool changeImage,
  ) async {
    try {
      final newImageName = image != null ? generateUUID() : null;

      final update =
          changeImage
              ? image == null
                  ? {
                    "name": name,
                    "ingredients": ingredientList,
                    "instructions": instructionList,
                    "groceries": groceryList,
                    "is_public": isPublic,
                    "image_name": null,
                  }
                  : {
                    "name": name,
                    "ingredients": ingredientList,
                    "instructions": instructionList,
                    "groceries": groceryList,
                    "is_public": isPublic,
                    "image_name": newImageName,
                  }
              : {
                "name": name,
                "ingredients": ingredientList,
                "instructions": instructionList,
                "groceries": groceryList,
                "is_public": isPublic,
              };

      final response =
          await _client.from("recipe").update(update).select("*").single();

      final recipeId = response["id"];
      final imageName = response["image_name"];

      // The one in the trillion chance that the UUID generated for the image name already exists, we want to prevent the recipe from being updated with an image name that doesn't match the one in storage
      if (imageName != newImageName) {
        return CreateRecipeResponse(
          success: false,
          localError: true,
          errorMessage:
              "Error: Recipe failed to be updated at this time, please try again later.",
        );
      }

      final success = true;

      await _client.from("recipe_group").delete().eq("recipe_id", recipeId);

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

  Future<List<Group>?> getGroupsForRecipe(String recipeId) async {
    try {
      final response = await _client
          .from("recipe_group")
          .select(
            "group_id, group (id, created_at, name, user_id, grade_visible, use_rating, is_personal_group)",
          )
          .eq("recipe_id", recipeId);

      if (response != null) {
        final groups =
            (response as List)
                .map(
                  (item) =>
                      Group.fromMap(item['group'] as Map<String, dynamic>),
                )
                .toList();
        return groups;
      }
    } catch (e) {
      print('Error fetching groups for recipe: $e');
    }
    return null;
  }
}
