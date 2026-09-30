import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<String> onChanged;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onChanged,
  });

  static const moods = [
    "😊 Happy",
    "😌 Calm",
    "😔 Sad",
    "😡 Angry",
    "😴 Tired",
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: moods.map((mood) {
        final selected = mood == selectedMood;

        return ChoiceChip(
          label: Text(mood),
          selected: selected,
          onSelected: (_) => onChanged(mood),
        );
      }).toList(),
    );
  }
}