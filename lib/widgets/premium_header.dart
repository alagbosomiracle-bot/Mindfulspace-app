import 'package:flutter/material.dart';
import 'fade_slide.dart';

class PremiumHeader extends StatelessWidget {
  final String greeting;
  final String name;

  const PremiumHeader({
    super.key,
    required this.greeting,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7F7FD5),
              Color(0xFF91EAE4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Small steps every day create lasting change.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}