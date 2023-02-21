import 'package:flutter/material.dart';

import '../models/Workout.dart';

class WorkoutRow extends StatelessWidget {
  final Workout workout;
  final Function() onTap;

  const WorkoutRow({
    required this.workout,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.fitness_center_outlined),
            trailing: const Icon(Icons.chevron_right),
            title: Text(
              workout.workoutName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
