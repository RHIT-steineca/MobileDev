import 'dart:async';
import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/WorkoutRow.dart';
import '../components/ExerciseRow.dart';
import '../managers/WorkoutCollectionManager.dart';
import '../models/Exercise.dart';
import '../models/Workout.dart';
import '../models/Workout.dart';
import 'LoginPage.dart';

class WorkoutInfo extends StatefulWidget {
  const WorkoutInfo({super.key});

  @override
  State<WorkoutInfo> createState() => _WorkoutInfo();
}

class _WorkoutInfo extends State<WorkoutInfo> {
  final titleTextController = TextEditingController();
  final urlTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Tracker"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((Route route) => false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const LoginPage();
              }));
            },
            tooltip: "Sign Out",
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      // body: FirestoreListView<Exercise>(
      //   query: WorkoutCollectionManager.instance.exercisesQuery(),
      //   itemBuilder: (context, snapshot) {
      //     Exercise exercise = snapshot.data();
      //     return ExerciseRow(
      //       exercise: exercise,
      //       onTap: () async {
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) {
      //       return ExerciseInfo(exercise.documentId!);
      //     },
      //   ),
      // );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
