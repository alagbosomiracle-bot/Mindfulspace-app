import 'package:flutter/material.dart';

class WellnessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const WellnessCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: .15),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}