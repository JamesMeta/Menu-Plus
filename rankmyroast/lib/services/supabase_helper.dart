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
}
