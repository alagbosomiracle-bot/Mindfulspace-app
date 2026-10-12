import 'package:flutter/material.dart';

class MeditationHeader extends StatelessWidget {
  const MeditationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Take a deep breath.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "Nothing needs your attention right now.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}