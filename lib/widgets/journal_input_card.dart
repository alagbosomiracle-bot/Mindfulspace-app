import 'package:flutter/material.dart';

class JournalInputCard extends StatelessWidget {
  final TextEditingController controller;

  const JournalInputCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: "What's on your mind today?",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}