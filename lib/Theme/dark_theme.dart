import 'package:flutter/material.dart';
import 'package:aichat/utils/dimensions.dart';

ThemeData dark = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: const Color.fromARGB(255, 43, 43, 44),
  brightness: Brightness.dark,
  highlightColor: const Color(0xFF252525),
  hintColor: const Color(0xFFc7c7c7),
  cardColor: const Color(0xFF242424),
  scaffoldBackgroundColor: const Color(0xFF000000),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 41, 42, 43),
    secondary: Color.fromARGB(255, 88, 96, 104),
    tertiary: Color(0xFF6C7A8E),
    tertiaryContainer: Color(0xFF6C7A8E),
    background: Color(0xFF2D2D2D),
    onPrimary: Color(0xFFB7D7FE),
    onTertiaryContainer: Color.fromARGB(255, 31, 255, 147),
    primaryContainer: Color(0xFF9AECC6),
    onSecondaryContainer: Color(0x912A2A2A),
    outline: Color.fromARGB(255, 29, 95, 181),
    onTertiary: Color(0xFF545252),
    secondaryContainer: Color(0xFFF2F2F2),
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Dimensions.fontSizeOverLarge,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 12.0,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
