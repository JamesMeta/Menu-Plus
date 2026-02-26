import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key, required this.extra});

  final List<String> extra;

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  @override
  void initState() {
    super.initState();
    _loopCheckIfVerified();
  }

  Future<void> _loopCheckIfVerified() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 5));
      await _checkIfVerified();
    }
  }

  Future<void> _checkIfVerified() async {
    final response = await Supabase.instance.client.auth.getUser();
    final user = response.user;
    if (user?.emailConfirmedAt != null) {
      if (mounted) {
        context.go('/home');
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please check your email to confirm your account.",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //TODO
              },
              child: const Text("Resend Confirmation Email"),
            ),
          ],
        ),
      ),
    );
  }
}
