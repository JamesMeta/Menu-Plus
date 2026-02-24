import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rankmyroast/screens/login/classes/ClippedContainer.dart';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 20,
                  child: ClipPath(
                    clipper: ClippedContainer(),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 100, 24, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 150,
                              child: SizedBox(
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
                            ),

                            Expanded(flex: 1, child: SizedBox()),

                            Expanded(
                              flex: 400,
                              child: SizedBox(
                                child: Image.asset(
                                  "assets/images/rankmyroast_icon4.png",
                                  width: screenWidth,
                                  scale: 1,
                                ),
                              ),
                            ),

                            Expanded(flex: 1, child: SizedBox()),

                            Expanded(
                              flex: 80,
                              child: Text(
                                "Sign In",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(flex: 1, child: SizedBox()),

                            TextField(
                              decoration: InputDecoration(
                                labelText: "Email",

                                border: OutlineInputBorder(),
                              ),
                            ),

                            Expanded(flex: 5, child: SizedBox()),

                            TextField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),

                            Expanded(flex: 20, child: SizedBox()),

                            Expanded(
                              flex: 100,
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    //TODO
                                  },
                                  style: ButtonStyle(
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
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(flex: 10, child: SizedBox()),

                            Expanded(
                              flex: 100,
                              child: ElevatedButton(
                                onPressed: _handleSignIn,
                                style: ButtonStyle(
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/2702/2702602.png",
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Continue With Google",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(flex: 1, child: SizedBox()),

                            TextButton(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),
                              onPressed: () {
                                context.push("/create-account");
                              },
                              child: Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
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
}
