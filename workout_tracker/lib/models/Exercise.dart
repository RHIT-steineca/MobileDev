import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_model_utils.dart';

const String kName = "name";
const String kReps = "reps";
const String kWeight = "weight";
const String kRest = "rest";

class Exercise {
  String name;
  int reps;
  int weight;
  int rest;

  Exercise({
    required this.name,
    required this.reps,
    required this.weight,
    required this.rest,
  });

  Exercise.from(Map<String, dynamic> map)
      : this(
          name: map[kName],
          reps: map[kReps],
          weight: map[kWeight],
          rest: map[kRest],
        );

  Map<String, Object?> toMap() {
    return {
      kName: name,
      kReps: reps,
      kWeight: weight,
      kRest: rest,
    };
  }
}
