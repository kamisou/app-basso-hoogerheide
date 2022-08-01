import 'package:flutter/material.dart';

final ThemeData appDarkThemeData = ThemeData(
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
  ),
  disabledColor: const Color(0xFF3F3F3F),
  extensions: const [
    _SuccessTheme(success: Color(0xFF318E31)),
  ],
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFF222222),
    hintStyle: TextStyle(
      color: Color(0xFF808080),
      fontFamily: 'Source Sans Pro',
    ),
    iconColor: Color(0xFF808080),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Color(0xFFF0F0F0),
      fontFamily: 'Source Sans Pro',
      fontSize: 24,
    ),
    labelLarge: TextStyle(
      color: Color(0xFFF0F0F0),
      fontFamily: 'Source Sans Pro',
      fontSize: 14,
    ),
    labelSmall: TextStyle(
      color: Color(0xFFF0F0F0),
      fontFamily: 'Source Sans Pro',
      fontSize: 11,
    ),
    titleMedium: TextStyle(
      color: Color(0xFFF0F0F0),
      fontFamily: 'Source Sans Pro',
      fontSize: 16,
    ),
  ),
  useMaterial3: true,
);

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
