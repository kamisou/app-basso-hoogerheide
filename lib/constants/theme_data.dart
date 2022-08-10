import 'package:flutter/material.dart';

ThemeData get appDarkThemeData {
  const String fontFamily = 'Source Sans Pro';
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA81818),
      onPrimary: Color(0xFFF0F0F0),
      secondary: Color(0xFF1A1A1A),
      onSecondary: Color(0xFFF0F0F0),
      error: Color(0xFFFA2D00),
      onError: Color(0xFFF0F0F0),
      background: Color(0xFF101010),
      onBackground: Color(0xFFF0F0F0),
      surface: Color(0xFF1A1A1A),
      onSurface: Color(0xFFF0F0F0),
      surfaceTint: Color(0x00000000),
    ),
    disabledColor: const Color(0xFF3F3F3F),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFA81818)),
        foregroundColor: MaterialStateProperty.all(const Color(0xFFF0F0F0)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    extensions: const [
      _SuccessTheme(success: Color(0xFF318E31)),
    ],
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF222222)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF222222)),
      ),
      fillColor: Color(0xFF222222),
      filled: true,
      hintStyle: TextStyle(
        color: Color(0xFF808080),
        fontFamily: fontFamily,
      ),
      iconColor: Color(0xFF808080),
    ),
    scaffoldBackgroundColor: const Color(0xFF101010),
    shadowColor: const Color(0x3F000000),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Color(0xFFF0F0F0),
        fontFamily: fontFamily,
        fontSize: 24,
      ),
      labelLarge: TextStyle(
        color: Color(0xFFF0F0F0),
        fontFamily: fontFamily,
        fontSize: 14,
      ),
      labelSmall: TextStyle(
        color: Color(0xFFF0F0F0),
        fontFamily: fontFamily,
        fontSize: 11,
      ),
      titleMedium: TextStyle(
        color: Color(0xFFF0F0F0),
        fontFamily: fontFamily,
        fontSize: 16,
      ),
    ),
    useMaterial3: true,
  );
}

class _SuccessTheme extends ThemeExtension<_SuccessTheme> {
  final Color? success;

  const _SuccessTheme({this.success});

  @override
  ThemeExtension<_SuccessTheme> copyWith({Color? success}) =>
      _SuccessTheme(success: this.success ?? success);

  @override
  ThemeExtension<_SuccessTheme> lerp(
      ThemeExtension<_SuccessTheme>? other, double t) {
    if (other is! _SuccessTheme) return this;
    return _SuccessTheme(success: Color.lerp(success, other.success, t));
  }
}
