import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_model_utils.dart';

const String kUserCollectionPath = "tracker-collections";
const String kUserId = "userId";
const String kWorkoutName = "workoutname";
const String kExercises = "exercises";

class Workout {
  String documentId;
  String userId;
  String workoutName;
  List<Map<String, dynamic>> exercises;

  Workout({
    required this.documentId,
    required this.userId,
    required this.workoutName,
    required this.exercises,
  });

  factory Workout.from(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> exercises =
        List<Map<String, dynamic>>.from(data[kExercises]);
    return Workout(
      documentId: doc.id,
      userId: data[kUserId],
      workoutName: data[kWorkoutName],
      exercises: exercises,
    );
  }

  Map<String, Object?> toMap() {
    return {
      kUserId: userId,
      kWorkoutName: workoutName,
      kExercises: exercises,
    };
  }
}
