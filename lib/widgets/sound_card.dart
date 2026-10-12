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
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isPlaying
            ? const LinearGradient(
                colors: [
                  Color(0xFF8587D8),
                  Color(0xFF79BEB5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPlaying ? null : Colors.white,
        border: Border.all(
          color: isPlaying
              ? Colors.transparent
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? const Color(0xFF8587D8)
                    .withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.035),
            blurRadius: isPlaying ? 18 : 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPlaying
                        ? Colors.white.withValues(alpha: 0.95)
                        : const Color(0xFFEAF4EF),
                  ),
                  child: Icon(
                    icon,
                    color: isPlaying
                        ? const Color(0xFF6869B9)
                        : const Color(0xFF4F8B72),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isPlaying
                              ? Colors.white
                              : const Color(0xFF292632),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isPlaying
                              ? Colors.white70
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    key: ValueKey(isPlaying),
                    size: 38,
                    color: isPlaying
                        ? Colors.white
                        : const Color(0xFF6D70C7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
          duration: 400.ms,
        );
  }
}