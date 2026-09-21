import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme textTheme(Color textColor) {
    return GoogleFonts.publicSansTextTheme().copyWith(
      displayLarge: GoogleFonts.publicSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.publicSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.publicSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.publicSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      labelLarge: GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelSmall: GoogleFonts.publicSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      ),
    );
  }
}
