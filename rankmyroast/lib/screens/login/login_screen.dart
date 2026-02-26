import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rankmyroast/screens/login/classes/clipped_container.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const serverClientId =
    "474584121880-5f7qh4hd4eonbpirt35mnddrlmahma9n.apps.googleusercontent.com";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(decoration: BoxDecoration(color: Colors.green)),
          ),

          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipPath(
                    clipper: ClippedContainer(),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.075,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rank My Roast",
                                        style: TextStyle(
                                          fontSize: 48,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Created By James Mata",
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              child: Image.asset(
                                "assets/images/rankmyroast_icon4.png",
                                width: screenWidth,
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign In",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 1),

                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: "Email",

                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                SizedBox(height: 2),

                                TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),

                                SizedBox(height: 4),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _handleSignIn,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.white,
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 4),

                                ElevatedButton(
                                  onPressed: _handleSignInWithGoogle,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.zero,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://cdn-icons-png.flaticon.com/512/2702/2702602.png",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Flexible(
                                            flex: 10,
                                            child: Text(
                                              "Continue With Google",
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.push("/login/create-account");
                                  },
                                  child: Text(
                                    "Don't have an account? Sign Up",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await SupabaseHelper.authSigninWithPassword(
      email,
      password,
    );

    if (mounted) {
      if (response.user?.role == "authenticated") {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Error: Unable to sign in with provided credentials',
            ),
            behavior: SnackBarBehavior.floating, // Recommended for modern UI
          ),
        );
      }
    }
  }

  Future<void> _handleSignInWithGoogle() async {
    final signInResponse = await signInWithGoogle();
    if (mounted) {
      if (signInResponse?.user?.role == "authenticated") {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Error: Unable to sign in with Google at this time',
            ),
            behavior: SnackBarBehavior.floating, // Recommended for modern UI
          ),
        );
      }
    }
  }

  Future<AuthResponse?> signInWithGoogle() async {
    final GoogleSignIn signIn = GoogleSignIn.instance;

    await signIn.initialize(serverClientId: serverClientId);

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } catch (e) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      return null;
    }

    final response = SupabaseHelper.authSigninWithIdToken(
      idToken,
      OAuthProvider.google,
    );

    return response;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
