import 'package:flutter/material.dart';

class GardenWidget extends StatelessWidget {
  final int entries;

  const GardenWidget({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    String emoji;
    String stage;

    if (entries < 5) {
      emoji = "🌱";
      stage = "Tiny Sprout";
    } else if (entries < 15) {
      emoji = "🌿";
      stage = "Growing Plant";
    } else if (entries < 40) {
      emoji = "🌳";
      stage = "Young Tree";
    } else if (entries < 80) {
      emoji = "🌳🌸";
      stage = "Blooming Tree";
    } else {
      emoji = "🌳🦋🌸";
      stage = "Flourishing Garden";
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            Text(
              emoji,
              style: const TextStyle(fontSize: 60),
            ),

            const SizedBox(height: 12),

            Text(
              stage,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "$entries moments of self-care",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}