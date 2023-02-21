import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'LoginPage.dart';
import 'WorkoutList.dart';

class MainLoginCheck extends StatelessWidget {
  const MainLoginCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoginPage();
        }
        return WorkoutList();
      },
    );
  }
}
