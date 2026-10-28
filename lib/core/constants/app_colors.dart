import 'package:flutter/material.dart';

class AppColors {
  // Primary & Accent Colors (Apple iOS Style)
  static const Color primary = Color(0xFF007AFF); // iOS System Blue
  static const Color primaryDark = Color(0xFF0A84FF);
  
  // Semantic Colors
  static const Color expense = Color(0xFFFF3B30); // iOS Red
  static const Color income = Color(0xFF34C759);  // iOS Green
  static const Color transfer = Color(0xFF5856D6); // iOS Purple
  static const Color warning = Color(0xFFFF9500);  // iOS Orange

  // Neutral Colors (Light Theme)
  static const Color backgroundLight = Color(0xFFF2F2F7);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1C1C1E);
  static const Color textSecondaryLight = Color(0xFF8E8E93);
  static const Color borderLight = Color(0xFFE5E5EA);

  // Neutral Colors (Dark Theme)
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color cardDark = Color(0xFF2C2C2E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  static const Color borderDark = Color(0xFF38383A);

  // Category Palette
  static const List<Color> categoryPalette = [
    Color(0xFFFF3B30),
    Color(0xFFFF9500),
    Color(0xFFFFCC00),
    Color(0xFF34C759),
    Color(0xFF00C7BE),
    Color(0xFF30B0C7),
    Color(0xFF007AFF),
    Color(0xFF5856D6),
    Color(0xFFAF52DE),
    Color(0xFFFF2D55),
    Color(0xFFA2845E),
    Color(0xFF8E8E93),
  ];
}
