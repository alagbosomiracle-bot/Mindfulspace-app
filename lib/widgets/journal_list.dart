import 'package:flutter/material.dart';
import 'journal_tile.dart';
import 'empty_state.dart';

class JournalList extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final Function(int id) onDelete;

  const JournalList({
    super.key,
    required this.entries,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const EmptyState(
        emoji: "🌿",
        title: "No Journal Yet",
        subtitle:
            "Start your wellness journey by writing your first reflection.",
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return JournalTile(
          entry: entry,
          onDelete: () => onDelete(entry['id']),
        );
      },
    );
  }
}