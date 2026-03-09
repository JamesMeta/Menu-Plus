import 'package:rankmyroast/models/group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final _client = Supabase.instance.client;

  static Future<AuthResponse> authSigninWithIdToken(
    String idToken,
    OAuthProvider provider,
  ) async {
    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    return response;
  }

  static Future<AuthResponse> authSigninWithPassword(
    String email,
    String password,
  ) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return response;
  }

  static Future<AuthResponse> authSignupWithPassword(
    String email,
    String password,
  ) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    return response;
  }

  static Future<void> authSignOut() async {
    await _client.auth.signOut();
  }

  static Future<void> addUser() async {
    final authId = _client.auth.currentUser?.id;

    if (authId != null) {
      final existingUser =
          await _client
              .from("user")
              .select("*")
              .eq("auth_id", authId)
              .maybeSingle();

      if (existingUser?["auth_id"] != null) {
        return;
      }

      try {
        final response = await _client.from("user").insert({"auth_id": authId});
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  static Future<bool> checkForUsername() async {
    final authId = _client.auth.currentUser?.id;
    if (authId != null) {
      try {
        final response =
            await _client
                .from("user")
                .select("username")
                .eq("auth_id", authId)
                .maybeSingle();
        final username = response?["username"];
        if (username == null) {
          return false;
        } else {
          return true;
        }
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    throw Exception("User not logged in");
  }

  static Future<bool> checkUsernameUniqueness(final String username) async {
    final authId = _client.auth.currentUser?.id;
    if (authId != null) {
      try {
        final response =
            await _client
                .from("user")
                .select("username")
                .eq("auth_id", authId)
                .maybeSingle();

        if (response?["username"] != null) {
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

  static Future<bool> setUsername(final String username) async {
    final authId = _client.auth.currentUser?.id;
    if (authId != null) {
      try {
        final response =
            await _client
                .from("user")
                .update({"username": username})
                .eq("auth_id", authId)
                .select()
                .single();

        if (response["username"] != null) {
          return true;
        }
        return false;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    throw Exception("User not logged in");
  }

  static Future<String?> getPublicId() async {
    final authId = _client.auth.currentUser?.id;
    if (authId != null) {
      try {
        final response = await _client
            .from("user")
            .select("public_id")
            .eq("auth_id", authId)
            .single()
            .limit(1);
        return response["public_id"];
      } on Exception catch (e) {
        print(e);
        return null;
      }
    }
    throw Exception("User not logged in");
  }

  static Future<bool?> createPersonalGroup() async {
    final authId = _client.auth.currentUser?.id;
    final publicId = await getPublicId();
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

  static Future<List<Group>?> getGroupsForUser() async {
    final authId = _client.auth.currentUser?.id;
    final publicId = await getPublicId();
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
        recipe_count:recipe_group(count),
        member_count:user_group(count)
      )
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
}
