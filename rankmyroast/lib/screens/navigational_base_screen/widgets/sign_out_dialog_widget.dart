import 'package:flutter/material.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:go_router/go_router.dart';

class SignOutDialogWidget extends StatelessWidget {
  const SignOutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await _signOut(context);
          },
          child: Text("Log Out"),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await SupabaseHelper.authSignOut();
    context.go("/login");
  }
}
