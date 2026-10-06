import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SoundCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SoundCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  bool get isPlaying => title.contains("Playing");

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isPlaying
            ? const LinearGradient(
                colors: [
                  Color(0xFF8EC5FC),
                  Color(0xFFE0C3FC),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPlaying ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? Colors.purple.withValues(alpha: .25)
                : Colors.black.withValues(alpha: .05),
            blurRadius: isPlaying ? 20 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isPlaying
                      ? Colors.white
                      : Colors.green.shade100,
                  child: Icon(
                    icon,
                    color: isPlaying
                        ? Colors.deepPurple
                        : Colors.green,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isPlaying
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isPlaying
                              ? Colors.white70
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    key: ValueKey(isPlaying),
                    size: 42,
                    color: isPlaying
                        ? Colors.white
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: .15);
  }
}