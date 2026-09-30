import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeSlide extends StatelessWidget {
  final Widget child;

  const FadeSlide({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fade(duration: 600.ms)
        .slideY(
          begin: .2,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }
}