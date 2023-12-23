import 'package:cilean/constants/theme/input_field_theme_data.dart';
import 'package:cilean/constants/theme/text_theme_data.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color onPrimary = Color(0xFF080E2C);
  static const Color onSecondary = Color(0xFF4E5CF6);
  static const Color background = Color(0xFFF8F8F8);

  ThemeData genData() {
    return ThemeData(
      /// Color Style
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF080E2C),
        onPrimary: onPrimary,
        secondary: Color(0xFF4E5CF6),
        onSecondary: onSecondary,
        error: Color(0xFFFB7272),
        onError: Color(0xFFFB7272),
        background: background,
        onBackground: Color(0xFFF8F8F8),
        surface: Color(0x6797A9FF),
        onSurface: Color(0x6797A9FF),
      ),

      inputDecorationTheme: InputFieldThemeData.genData(),
      textTheme: TextThemeData.genData(),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
