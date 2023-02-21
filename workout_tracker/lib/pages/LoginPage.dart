import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workout_tracker/pages/MainLoginCheck.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Welcome to Workout Tracker",
                  style: TextStyle(
                    fontFamily: "Rowdies",
                    fontSize: 56.0,
                  ),
                ),
              ],
            ),
            LoginButton(
                title: "Sign in",
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SignInScreen(
                          showAuthActionSwitch: false,
                          providerConfigs: [
                            GoogleProviderConfiguration(
                              clientId:
                                  '623948250926-hkm3u7egama65c8p9ifc5c2f3cq31ni4.apps.googleusercontent.com',
                            ),
                          ],
                          actions: [
                            AuthStateChangeAction<SignedIn>((context, _) {
                              Navigator.of(context)
                                  .popUntil((Route route) => false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return MainLoginCheck();
                                }),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String title;
  final Function() callback;
  const LoginButton({
    required this.title,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        width: 250.0,
        margin: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: callback,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
        ));
  }
}
