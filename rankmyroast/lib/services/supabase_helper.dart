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
}
