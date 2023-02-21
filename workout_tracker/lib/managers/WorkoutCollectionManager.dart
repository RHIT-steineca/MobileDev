import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Exercise.dart';
import '../models/Workout.dart';

const String kUserCollectionPath = "tracker-collections";

class WorkoutCollectionManager {
  Workout? latestWorkout;
  final CollectionReference _ref;

  static final WorkoutCollectionManager instance =
      WorkoutCollectionManager._privateConstructor();

  WorkoutCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kUserCollectionPath);

  StreamSubscription startListening(String documentId, Function observer) {
    return _ref
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      latestWorkout = Workout.from(docSnapshot);
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> addWorkout({
    required String workoutname,
  }) {
    return _ref
        .add({
          kUserId: FirebaseAuth.instance.currentUser?.uid,
          kWorkoutName: workoutname,
          kExercises: [],
        })
        .then((DocumentReference docRef) =>
            print("Workout added with id ${docRef.id}"))
        .catchError((error) => print("Failed to add Workout: $error"));
  }

  Query<Workout> get workoutsQuery => _ref
      .withConverter<Workout>(
        fromFirestore: (snapshot, _) => Workout.from(snapshot),
        toFirestore: (workout, _) => workout.toMap(),
      )
      .where(kUserId, isEqualTo: FirebaseAuth.instance.currentUser!.uid);
}
