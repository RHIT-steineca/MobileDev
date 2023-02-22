import 'dart:async';
import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/WorkoutRow.dart';
import '../components/ExerciseRow.dart';
import '../managers/WorkoutCollectionManager.dart';
import '../models/Workout.dart';
import 'LoginPage.dart';

class WorkoutInfo extends StatefulWidget {
  final String documentId;
  const WorkoutInfo(this.documentId, {super.key});

  @override
  State<WorkoutInfo> createState() => _WorkoutInfo();
}

class _WorkoutInfo extends State<WorkoutInfo> {
  List<Map<String, dynamic>> exercises = [];
  String name = "Name";

  final workoutTextController = TextEditingController();
  final exerciseTextController = TextEditingController();

  StreamSubscription? workoutSubscription;

  @override
  void initState() {
    super.initState();
    workoutSubscription = WorkoutCollectionManager.instance.startListening(
      widget.documentId,
      () {
        setState(() {
          exercises =
              WorkoutCollectionManager.instance.latestWorkout!.exercises;
          name = WorkoutCollectionManager.instance.latestWorkout!.workoutName;
        });
      },
    );
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final exercise = exercises.removeAt(oldindex);
      exercises.insert(newindex, exercise);
    });
  }

  void sorting() {
    setState(() {
      exercises.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Workout Tracker"),
          actions: [
            IconButton(
              onPressed: () {
                workoutTextController.text = WorkoutCollectionManager
                    .instance.latestWorkout!.workoutName;
                showEditWorkoutDialog(context);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 10),
                    content: SnackBarAction(
                      label:
                          'Only click this if you are ABSOLUTELY SURE that you would like to delete this workout',
                      onPressed: () {
                        WorkoutCollectionManager.instance
                            .stopListening(workoutSubscription);
                        WorkoutCollectionManager.instance.deleteWorkout();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
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
        body: Row(
          children: [Text(name)],
        )
        // body: ReorderableListView(
        //   onReorder: reorderData,
        //   children: <Widget>[
        //     for (final exercise in widget.exercises)
        //       ExerciseRow(
        //         exercise: exercise,
        //         onTap: () {
        //           showEditExerciseDialog(context);
        //         },
        //       )
        //   ],
        // )
        );
  }

  Future<void> showEditWorkoutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: workoutTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Edit the Workout\'s name',
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
              child: const Text('Rename'),
              onPressed: () {
                setState(() {
                  WorkoutCollectionManager.instance.updateWorkout(
                    workoutName: workoutTextController.text,
                    exercises: exercises,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditExerciseDialog(BuildContext context) {
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
                  controller: exerciseTextController,
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
                setState(() {
                  WorkoutCollectionManager.instance.addWorkout(
                    workoutname: exerciseTextController.text,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
