import 'package:cilean/constants/config/theme_config.dart';
import 'package:flutter/material.dart';

class InputFieldThemeData {
  static InputDecorationTheme genData() {
    return InputDecorationTheme(
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: ThemeConfig.onPrimary,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: ThemeConfig.onPrimary.withOpacity(0.1),
        ),
      ),
    );
  }
}
