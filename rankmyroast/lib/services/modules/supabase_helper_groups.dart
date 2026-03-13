import 'package:rankmyroast/models/create_group_response.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/group_member.dart';
import 'package:rankmyroast/services/modules/supabase_helper_users.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelperGroups {
  static final _client = Supabase.instance.client;

  Future<bool?> createPersonalGroup() async {
    final authId = _client.auth.currentUser?.id;
    if (authId != null) {
      try {
        final existingGroup =
            await _client
                .from("group")
                .select("*")
                .eq("user_id", authId)
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
                  "user_id": authId,
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
                  "user_id": authId,
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
    if (authId != null) {
      try {
        // Not sure if this is the best way to do this,
        // in theory it should work because RLS should only return groups the user is a member of
        final response = await _client.from("full_group_details").select();

        final List<Group> groups =
            (response as List).map((data) => Group.fromMap(data)).toList();

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

    if (authId != null) {
      try {
        // Add the group to the database

        final response =
            await _client
                .from("group")
                .insert({
                  "name": group.name,
                  "grade_visible": group.gradeVisible,
                  "use_rating": group.useRating,
                  "is_personal_group": false,
                  "user_id": authId,
                })
                .select()
                .single();

        if (response["id"] == null) {
          return CreateGroupResponse(success: false);
        }

        // Add self to group

        final selfAddResponse =
            await _client
                .from("user_group")
                .insert({
                  "group_id": response["id"],
                  "user_id": authId,
                  "permission_level": 3,
                })
                .select()
                .single();

        if (selfAddResponse["id"] == null) {
          await _client.from("group").delete().eq("group_id", response["id"]);

          return CreateGroupResponse(success: false);
        }

        // Add the users to group

        final List<GroupMember> failedAdditions = [];

        for (var user in group.groupMembers) {
          final userAuthId =
              await _client
                  .from("user")
                  .select("auth_id")
                  .eq("username", user.username)
                  .limit(1)
                  .single();
          final userGroupResponse =
              await _client
                  .from("user_group")
                  .insert({
                    "group_id": response["id"],
                    "user_id": userAuthId["auth_id"],
                    "permission_level": user.permissionLevel,
                  })
                  .select()
                  .single();

          if (userGroupResponse["id"] == null) {
            failedAdditions.add(user);
          }
        }

        return CreateGroupResponse(
          success: true,
          failedToAddMembers: failedAdditions,
        );
      } on Exception catch (e) {
        print(e);
        return CreateGroupResponse(success: false);
      }
    }
    throw Exception("User not logged in");
  }
}
