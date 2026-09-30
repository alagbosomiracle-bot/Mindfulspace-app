import 'package:flutter/material.dart';

class MoodHistoryCard extends StatelessWidget {
  final String mood;
  final DateTime createdAt;

  const MoodHistoryCard({
    super.key,
    required this.mood,
    required this.createdAt,
  });

  String getMoodEmoji(String mood) {
    switch (mood) {
      case "Happy":
        return "😊";
      case "Sad":
        return "😔";
      case "Anxious":
        return "😰";
      case "Angry":
        return "😡";
      case "Tired":
        return "😴";
      case "Loved":
        return "❤️";
      default:
        return "🌿";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Text(
          getMoodEmoji(mood),
          style: const TextStyle(fontSize: 30),
        ),
        title: Text(
          mood,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          "${createdAt.day.toString().padLeft(2, '0')}/"
          "${createdAt.month.toString().padLeft(2, '0')}/"
          "${createdAt.year}",
        ),
      ),
    );
  }
}