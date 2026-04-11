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
      final ingredientsText = ingredientList?.join("/%/");
      final instructionText = instructionList?.join("/%/");
      final groceryText = groceryList?.join("/%/");

      final response =
          await _client
              .from("Recipe")
              .insert({
                "name": name,
                "ingredients": ingredientsText,
                "instructions": instructionText,
                "groceries": groceryText,
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

      final failedGroups = <Group>[];

      final recipeGroupResponse = await Future.wait(
        groupList.map(
          (group) => _client
              .from("recipe_group")
              .insert({"recipe_id": recipeId, "group_id": group.id})
              .select("*")
              .single()
              .then((r) {
                if (r["id"] == null) {
                  failedGroups.add(group);
                }
              }),
        ),
      );

      if (image != null) {
        final imageResponse = await SupabaseHelper.storage.uploadFileToBucket(
          bucketName: "public_recipe_image",
          file: image,
          fileName: imageName,
        );

        if (imageResponse != null) {
          return CreateRecipeResponse(
            success: success,
            failedToAddGroups: failedGroups,
          );
        } else {
          return CreateRecipeResponse(
            success: success,
            failedToAddGroups: failedGroups,
            failedToUploadImage: true,
          );
        }
      } else {
        return CreateRecipeResponse(
          success: success,
          failedToAddGroups: failedGroups,
        );
      }
    } catch (e) {
      return CreateRecipeResponse(
        success: false,
        localError: false,
        errorMessage: e.toString(),
      );
    }
  }
}
