import 'package:flutter/material.dart';

class QuietCornerScreen extends StatelessWidget {
  const QuietCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = [
      {
        "title": "Rain",
        "emoji": "🌧",
        "subtitle": "Gentle rain for relaxation"
      },
      {
        "title": "Ocean",
        "emoji": "🌊",
        "subtitle": "Calming ocean waves"
      },
      {
        "title": "Forest",
        "emoji": "🍃",
        "subtitle": "Peaceful forest ambience"
      },
      {
        "title": "Night",
        "emoji": "🌙",
        "subtitle": "Crickets and soft night sounds"
      },
      {
        "title": "Piano",
        "emoji": "🎹",
        "subtitle": "Soft instrumental piano"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiet Corner"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sounds.length,
        itemBuilder: (_, index) {
          final sound = sounds[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              leading: Text(
                sound["emoji"]!,
                style: const TextStyle(fontSize: 30),
              ),
              title: Text(sound["title"]!),
              subtitle: Text(sound["subtitle"]!),
              trailing: const Icon(Icons.play_circle_fill),
            ),
          );
        },
      ),
    );
  }
}