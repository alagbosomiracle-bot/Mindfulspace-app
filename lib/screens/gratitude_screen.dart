import 'package:flutter/material.dart';

class GratitudeScreen extends StatelessWidget {
  const GratitudeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gratitude"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Text(
              "What are three things you're grateful for today?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: "1...",
              ),
            ),

            SizedBox(height: 15),

            TextField(
              decoration: InputDecoration(
                hintText: "2...",
              ),
            ),

            SizedBox(height: 15),

            TextField(
              decoration: InputDecoration(
                hintText: "3...",
              ),
            ),
          ],
        ),
      ),
    );
  }
}