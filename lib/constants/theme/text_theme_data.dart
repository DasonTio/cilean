import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextThemeData {
  static TextTheme genData() {
    return TextTheme(
      headlineLarge: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 32,
      ),
      headlineMedium: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 38,
      ),
      headlineSmall: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 24,
      ),
      titleLarge: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 18,
      ),
      bodyMedium: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 16,
      ),
      bodySmall: GoogleFonts.poppins(
        // fontFamily: 'Nexa',
        fontSize: 14,
      ),
    );
  }
}
