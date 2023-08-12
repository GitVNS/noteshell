import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder()
    }),
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.w900,
      ),
      headlineMedium: TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
