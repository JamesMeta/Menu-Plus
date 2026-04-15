import 'package:rankmyroast/classes/responses/create_group_response.dart';
import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/group_member.dart';
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
          return CreateGroupResponse(
            success: false,
            localError: true,
            errorMessage: "Failed to create group, Database Rejected Insert",
          );
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

          if (userAuthId["auth_id"] == null) {
            failedAdditions.add(user);
            continue;
          }

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
        return CreateGroupResponse(
          success: false,
          localError: true,
          errorMessage: e.toString(),
        );
      }
    }
    throw Exception("User not logged in");
  }

  Future<CreateGroupResponse> updateGroup(Group group) async {
    final authId = _client.auth.currentUser?.id;

    if (authId != null) {
      try {
        // Update the group in the database

        if (group.isPersonalGroup) {
          return CreateGroupResponse(
            success: false,
            localError: true,
            errorMessage: "Personal groups cannot be edited",
          );
        }

        final response =
            await _client
                .from("group")
                .update({
                  "name": group.name,
                  "grade_visible": group.gradeVisible,
                  "use_rating": group.useRating,
                })
                .eq("id", group.id)
                .select()
                .single();

        if (response["id"] == null) {
          return CreateGroupResponse(
            success: false,
            localError: true,
            errorMessage: "Failed to update group, Database Rejected Update",
          );
        }

        final List<GroupMember> failedToAddMembers = [];

        for (var member in group.groupMembers) {
          final userAuthId =
              await _client
                  .from("user")
                  .select("auth_id")
                  .eq("username", member.username)
                  .limit(1)
                  .single();

          if (userAuthId["auth_id"] == null) {
            failedToAddMembers.add(member);
            continue;
          }

          final userGroupResponse =
              await _client
                  .from("user_group")
                  .upsert({
                    "group_id": group.id,
                    "user_id": userAuthId["auth_id"],
                    "permission_level": member.permissionLevel,
                  }, onConflict: "group_id, user_id")
                  .eq("group_id", group.id)
                  .eq("user_id", userAuthId["auth_id"])
                  .select()
                  .single();

          if (userGroupResponse["id"] == null) {
            failedToAddMembers.add(member);
            continue;
          }
        }

        return CreateGroupResponse(
          success: true,
          failedToAddMembers: failedToAddMembers,
        );
      } on Exception catch (e) {
        print(e);
        return CreateGroupResponse(
          success: false,
          localError: true,
          errorMessage: e.toString(),
        );
      }
    }
    throw Exception("User not logged in");
  }

  Future<bool> deleteGroup(String groupId) async {
    final authId = _client.auth.currentUser?.id;

    if (authId != null) {
      try {
        final response = await _client
            .from("group")
            .delete()
            .eq("id", groupId)
            .eq("user_id", authId);

        final confirmDelete =
            await _client
                .from("group")
                .select("id")
                .eq("id", groupId)
                .maybeSingle();

        if (confirmDelete == null) {
          return true;
        }
        return false;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}
