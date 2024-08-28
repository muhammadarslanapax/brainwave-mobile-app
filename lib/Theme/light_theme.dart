import 'package:flutter/material.dart';
import 'package:aichat/utils/dimensions.dart';

ThemeData light = ThemeData(
  fontFamily: 'roboto',
  primaryColor: const Color(0xFF1455AC),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFF9E9E9E),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1455AC),
    secondary: Color(0xFF004C8E),
    tertiary: Color(0xFFF9D4A8),
    tertiaryContainer: Color(0xFFADC9F3),
    onTertiaryContainer: Color(0xFF33AF74),
    onPrimary: Color(0xFF7FBBFF),
    background: Color(0xFFF4F8FF),
    onSecondary: Color(0xFFF88030),
    error: Color(0xFFFF5555),
    onSecondaryContainer: Color(0xFFF3F9FF),
    outline: Color(0xff2C66B4),
    onTertiary: Color(0xFFE9F3FF),
    primaryContainer: Color(0xFF9AECC6),
    secondaryContainer: Color(0xFFF2F2F2),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'roboto',
      fontSize: Dimensions.fontSizeOverLarge,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: 'roboto',
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.black,
    ),
    displaySmall: TextStyle(
      fontFamily: 'roboto',
      fontWeight: FontWeight.w500,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'roboto',
      fontWeight: FontWeight.w600,
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.black,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: 'roboto',
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w800,
      fontFamily: 'roboto',
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: 'roboto',
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 15.0,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 12.0,
      fontFamily: 'roboto',
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'roboto',
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
);
