import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF9D8DFF);

  static const Color background = Color(0xFFF8F8FC);

  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1B1B1F);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color success = Color(0xFF4CAF50);

  static const Color error = Color(0xFFE53935);

  static const Color border = Color(0xFFE6E6EF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF7B61FF),
      Color(0xFF9C8BFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}