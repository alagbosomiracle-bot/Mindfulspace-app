import 'package:flutter/material.dart';

class MeditationHeader extends StatelessWidget {
  const MeditationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [

        SizedBox(height: 20),

        Text(
          "Take a deep breath.",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Text(
          "Nothing needs your attention right now.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),

        SizedBox(height: 40),

      ],
    );
  }
}