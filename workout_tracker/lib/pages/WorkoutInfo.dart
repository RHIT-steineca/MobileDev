import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
  final exerciseNameController = TextEditingController();
  final exerciseRepsController = TextEditingController();
  final exerciseWeightController = TextEditingController();
  final exerciseRestController = TextEditingController();

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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      Map<String, dynamic> exercise = exercises.removeAt(oldindex);
      exercises.insert(newindex, exercise);
      WorkoutCollectionManager.instance.updateWorkout(
        workoutName:
            WorkoutCollectionManager.instance.latestWorkout!.workoutName,
        exercises: exercises,
      );
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
              workoutTextController.text =
                  WorkoutCollectionManager.instance.latestWorkout!.workoutName;
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Text(
              name,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Flexible(
            child: ReorderableListView(
              onReorder: reorderData,
              children: [
                for (Map<String, dynamic> exercise in exercises)
                  ExerciseRow(
                    key: ValueKey(exercise),
                    exercise: exercise["name"],
                    onTap: () {
                      exerciseNameController.text = exercise["name"];
                      exerciseRepsController.text = exercise["reps"].toString();
                      exerciseWeightController.text =
                          exercise["weight"].toString();
                      exerciseRestController.text = exercise["rest"].toString();
                      showEditExerciseDialog(context, exercise);
                    },
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: TextButton(
              child: Text("Add Exercise"),
              onPressed: () {
                exerciseNameController.text = "";
                exerciseRepsController.text = "";
                exerciseWeightController.text = "";
                exerciseRestController.text = "";
                showCreateExerciseDialog(context);
              },
            ),
          ),
        ],
      ),
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
                if (!workoutTextController.text.isEmpty) {
                  setState(() {
                    WorkoutCollectionManager.instance.updateWorkout(
                      workoutName: workoutTextController.text,
                      exercises: exercises,
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

  Future<void> showCreateExerciseDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseNameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the Exercise\'s Name',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseRepsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Exercise Reps',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseWeightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Exercise Weight',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseRestController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Exercise Rest Period (seconds)',
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
                if (!exerciseNameController.text.isEmpty &&
                    !exerciseRepsController.text.isEmpty &&
                    !exerciseWeightController.text.isEmpty &&
                    !exerciseRestController.text.isEmpty) {
                  setState(() {
                    Map<String, dynamic> newExercise = <String, dynamic>{};
                    newExercise["name"] = exerciseNameController.text;
                    newExercise["reps"] =
                        int.parse(exerciseRepsController.text);
                    newExercise["weight"] =
                        int.parse(exerciseWeightController.text);
                    newExercise["rest"] =
                        int.parse(exerciseRestController.text);
                    exercises.add(newExercise);
                    WorkoutCollectionManager.instance.updateWorkout(
                      workoutName: WorkoutCollectionManager
                          .instance.latestWorkout!.workoutName,
                      exercises: exercises,
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

  Future<void> showEditExerciseDialog(
      BuildContext context, Map<String, dynamic> exercise) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Exercise data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseNameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the Exercise\'s Name',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseRepsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Exercise Reps',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseWeightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Exercise Weight',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: exerciseRestController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Exercise Rest Period (seconds)',
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
              child: const Text('Delete'),
              onPressed: () {
                exercises.remove(exercise);
                WorkoutCollectionManager.instance.updateWorkout(
                  workoutName: WorkoutCollectionManager
                      .instance.latestWorkout!.workoutName,
                  exercises: exercises,
                );
                Navigator.of(context).pop();
              },
            ),
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
              child: const Text('Save'),
              onPressed: () {
                if (!exerciseNameController.text.isEmpty &&
                    !exerciseRepsController.text.isEmpty &&
                    !exerciseWeightController.text.isEmpty &&
                    !exerciseRestController.text.isEmpty) {
                  setState(() {
                    exercise["name"] = exerciseNameController.text;
                    exercise["reps"] = int.parse(exerciseRepsController.text);
                    exercise["weight"] =
                        int.parse(exerciseWeightController.text);
                    exercise["rest"] = int.parse(exerciseRestController.text);
                    WorkoutCollectionManager.instance.updateWorkout(
                      workoutName: WorkoutCollectionManager
                          .instance.latestWorkout!.workoutName,
                      exercises: exercises,
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
