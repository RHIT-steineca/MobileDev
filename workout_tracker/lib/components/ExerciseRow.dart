import 'package:flutter/material.dart';

import '../models/Workout.dart';

class ExerciseRow extends StatelessWidget {
  final String exercise;
  final Function() onTap;

  const ExerciseRow({
    required this.exercise,
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
            title: Text(
              exercise,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
