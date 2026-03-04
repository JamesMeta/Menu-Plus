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
        final response = await _client
            .from("user")
            .select("username")
            .eq("auth_id", authId)
            .single()
            .limit(1);
        final username = response["username"];
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
        final response = await _client
            .from("user")
            .select("username")
            .eq("auth_id", authId)
            .single()
            .limit(1);

        if (response["username"] != null) {
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
}
