import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/services/modules/supabase_helper_auth.dart';
import 'package:rankmyroast/services/modules/supabase_helper_groups.dart';
import 'package:rankmyroast/services/modules/supabase_helper_users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final _client = Supabase.instance.client;
  static final groups = SupabaseHelperGroups();
  static final auth = SupabaseHelperAuth();
  static final users = SupabaseHelperUsers();
}
