import 'package:cloud_firestore/cloud_firestore.dart';
import 'Exercise.dart';
import 'firestore_model_utils.dart';

const String kUserCollectionPath = "tracker-collections";
const String kUserId = "userId";
const String kWorkoutName = "workoutname";
const String kExercises = "exercises";

class Workout {
  String? documentId;
  String userId;
  String workoutName;

  Workout({
    this.documentId,
    required this.userId,
    required this.workoutName,
  });

  Workout.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          userId: FirestoreModelUtils.getStringField(doc, kUserId),
          workoutName: FirestoreModelUtils.getStringField(doc, kWorkoutName),
        );

  Map<String, Object?> toMap() {
    return {
      kUserId: userId,
      kWorkoutName: workoutName,
    };
  }
}
