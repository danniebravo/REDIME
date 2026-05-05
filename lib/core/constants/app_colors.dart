import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette (from Figma)
  static const Color primaryTeal = Color(0xFF2E7D6F);
  static const Color darkTeal = Color(0xFF2C6B5A);
  static const Color lightMint = Color(0xFFC5E8E0);
  static const Color mintBackground = Color(0xFFE8F5F1);
  static const Color tealSurface = Color(0xFF3D8B7A);

  // Aliases used by Alex's pickup/recycling flow
  static const Color teal = primaryTeal;
  static const Color darkestTeal = darkTeal;
  static const Color background = mintBackground;
  static const Color textMain = darkText;
  static const Color lightTeal = lightMint;
  static const Color otherSelectedBg = cardSelected;
  static const Color disabledButton = disabledGrey;
  static const Color disabledText = greySubtitle;

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color greySubtitle = Color(0xFF6B6B6B);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color disabledGrey = Color(0xFFBDBDBD);
  static const Color borderGrey = Color(0xFFE0E0E0);

  // Accents
  static const Color confirmationGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53935);

  // Welcome screen circles
  static const Color welcomeDarkCircle = Color(0xFF344E47);
  static const Color welcomeMediumCircle = Color(0xFF4A8B7C);
  static const Color welcomeMintBg = Color(0xFFA8D5C8);

  // Card backgrounds (from Figma grid)
  static const Color cardLightMint = Color(0xFFB8DED5);
  static const Color cardMediumTeal = Color(0xFF7AB8A8);
  static const Color cardDarkTeal = Color(0xFF2C6B5A);
  static const Color cardSelected = Color(0xFFE8F5F1);
}
