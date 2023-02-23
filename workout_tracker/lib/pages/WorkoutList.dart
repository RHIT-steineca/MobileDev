import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/WorkoutRow.dart';
import '../managers/WorkoutCollectionManager.dart';
import '../models/Workout.dart';
import '../models/Workout.dart';
import 'LoginPage.dart';
import 'WorkoutInfo.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutList();
}

class _WorkoutList extends State<WorkoutList> {
  final newWorkoutTextController = TextEditingController();

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
      body: FirestoreListView<Workout>(
        query: WorkoutCollectionManager.instance.workoutsQuery,
        itemBuilder: (context, snapshot) {
          Workout workout = snapshot.data();
          return WorkoutRow(
            workout: workout,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return WorkoutInfo(workout.documentId);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newWorkoutTextController.text = "";
          showCreateWorkoutDialog(context);
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showCreateWorkoutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a new Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: newWorkoutTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the Workout\'s name',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                if (!newWorkoutTextController.text.isEmpty) {
                  setState(() {
                    WorkoutCollectionManager.instance.addWorkout(
                      workoutname: newWorkoutTextController.text,
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
