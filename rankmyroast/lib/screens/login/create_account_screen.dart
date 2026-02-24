import 'package:flutter/material.dart';
import 'package:rankmyroast/screens/login/classes/ClippedContainer.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 100,
                        ),
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
                              flex: 500,
                              child: SizedBox(
                                child: Image.asset(
                                  "assets/images/rankmyroast_icon3.png",
                                  width: screenWidth,
                                  scale: 1,
                                ),
                              ),
                            ),

                            Expanded(flex: 1, child: SizedBox()),

                            Expanded(
                              flex: 80,
                              child: Text(
                                "Create Account",
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

                            Expanded(flex: 5, child: SizedBox()),

                            TextField(
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
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
                                      "Create Account",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(flex: 10, child: SizedBox()),

                            Expanded(flex: 1, child: SizedBox()),
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
}
