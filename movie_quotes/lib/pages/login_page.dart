import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
        actions: [],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: SizedBox(
            width: 700.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Login Page!")],
            ),
          ),
        ),
      ),
    );
  }
}
