import 'package:flutter/material.dart';

class BreatheScreen extends StatelessWidget {
  const BreatheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathe"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.self_improvement,
              size: 120,
            ),

            SizedBox(height: 30),

            Text(
              "Take a slow breath in...",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            Text(
              "Hold for four seconds.\nThen slowly breathe out.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}