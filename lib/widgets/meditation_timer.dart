import 'package:flutter/material.dart';

class MeditationTimer extends StatelessWidget {

  final String time;

  const MeditationTimer({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {

    return Text(
      time,
      style: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
      ),
    );

  }
}