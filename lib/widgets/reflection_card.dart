import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class ReflectionCard extends StatelessWidget {
  final JournalEntry entry;

  const ReflectionCard({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              entry.mood,
              style: const TextStyle(fontSize: 34),
            ),

            const SizedBox(height: 12),

            Text(
              entry.content,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 15),

            Text(
  "${entry.createdAt.day.toString().padLeft(2, '0')}/${entry.createdAt.month.toString().padLeft(2, '0')}/${entry.createdAt.year}",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}