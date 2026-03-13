import 'package:rankmyroast/models/create_group_response.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/services/modules/supabase_helper_users.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelperGroups {
  static final _client = Supabase.instance.client;

  Future<bool?> createPersonalGroup() async {
    final authId = _client.auth.currentUser?.id;
    final publicId = await SupabaseHelper.users.getPublicId();
    if (authId != null && publicId != null) {
      try {
        final existingGroup =
            await _client
                .from("group")
                .select("*")
                .eq("user_id", publicId)
                .eq("is_personal_group", true)
                .maybeSingle();

        if (existingGroup?["id"] != null) {
          return true;
        }

        final response =
            await _client
                .from("group")
                .insert({
                  "name": "Personal Group",
                  "grade_visible": false,
                  "use_rating": false,
                  "is_personal_group": true,
                  "user_id": publicId,
                })
                .select()
                .single();

        if (response["id"] == null) {
          return false;
        }

        final userGroupResponse =
            await _client
                .from("user_group")
                .insert({
                  "user_id": publicId,
                  "group_id": response["id"],
                  "permission_level": 3,
                })
                .select()
                .single();
        if (userGroupResponse["id"] == null) {
          return false;
        }

        return true;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    throw Exception("User not logged in");
  }

  Future<List<Group>?> getGroupsForUser() async {
    final authId = _client.auth.currentUser?.id;
    final publicId = await SupabaseHelper.users.getPublicId();
    if (publicId != null) {
      try {
        final response = await _client
            .from("user_group")
            .select('''
      *,
      group:group_id (
        id, 
        created_at, 
        name, 
        grade_visible, 
        use_rating, 
        is_personal_group, 
        user_id,
        recipes:recipe_group(id, created_at, recipe_id, group_id, recipe:recipe(id, created_at, name, avatar_url, ingredients, instructions, is_public, user_id)),
        members:user_group(id, created_at, group_id, user_id, permission_level, user:user(id, created_at, auth_id, public_id, username, is_public))
      ),
    ''')
            .eq("user_id", publicId);

        final groups =
            (response as List).map((group) {
              final groupData = group["group"];
              final memberCount = groupData["member_count"][0]["count"];
              final recipeCount = groupData["recipe_count"][0]["count"];
              return Group(
                id: groupData["id"],
                created_at: groupData["created_at"],
                name: groupData["name"],
                grade_visible: groupData["grade_visible"],
                use_rating: groupData["use_rating"],
                is_personal_group: groupData["is_personal_group"],
                user_id: groupData["user_id"],
                number_of_members: memberCount,
                number_of_recipes: recipeCount,
              );
            }).toList();

        return groups;
      } on Exception catch (e) {
        print(e);
        return null;
      }
    }
    throw Exception("User not logged in");
  }

  Future<CreateGroupResponse> createGroup(Group group) async {
    final authId = _client.auth.currentUser?.id;
    final publicId = await SupabaseHelper.users.getPublicId();

    if (authId != null && publicId != null) {
      try {
        final response =
            await _client
                .from("group")
                .insert({
                  "name": group.name,
                  "grade_visible": group.grade_visible,
                  "use_rating": group.use_rating,
                  "is_personal_group": false,
                  "user_id": publicId,
                })
                .select()
                .single();

        if (response["id"] == null) {
          return CreateGroupResponse(
            success: false,
          );
        }

        for(final groupMember in group.)



      } on Exception catch (e) {
        print(e);
        return CreateGroupResponse(
            success: false,
          );
      }
    }
  }
}
