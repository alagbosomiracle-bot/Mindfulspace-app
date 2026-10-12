import 'package:flutter/material.dart';

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key});

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    animation = Tween<double>(
      begin: 155,
      end: 205,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Container(
          width: animation.value + 28,
          height: animation.value + 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7E8CE0).withValues(alpha: 0.18),
                blurRadius: 30,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: animation.value,
              height: animation.value,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9D9FE8),
                    Color(0xFF79C9BD),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.self_improvement_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}