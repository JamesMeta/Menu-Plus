import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelperUsers {
  static final _client = Supabase.instance.client;

  Future<void> addUser() async {
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

  Future<bool> checkForUsername() async {
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

  Future<bool> checkUsernameUniqueness(final String username) async {
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

  Future<bool> setUsername(final String username) async {
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

  Future<String?> getPublicId() async {
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
}
