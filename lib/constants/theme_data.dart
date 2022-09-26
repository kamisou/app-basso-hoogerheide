import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  ThemeData get dark {
    const String fontFamily = 'Source Sans Pro';
    return ThemeData(
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        surfaceTintColor: const Color(0x00000000),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFA81818),
        onPrimary: Color(0xFFF0F0F0),
        secondary: Color(0xFF808080),
        onSecondary: Color(0xFFF0F0F0),
        error: Color(0xFFF34923),
        onError: Color(0xFFF0F0F0),
        background: Color(0xFF101010),
        onBackground: Color(0xFFF0F0F0),
        surface: Color(0xFF1A1A1A),
        onSurface: Color(0xFFF0F0F0),
        surfaceTint: Color(0x00000000),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
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
        SuccessThemeExtension(success: Color(0xFF318E31)),
      ],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF222222)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF222222)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF34923)),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFF34923),
          fontFamily: fontFamily,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF222222)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF34923)),
        ),
        fillColor: const Color(0xFF222222),
        filled: true,
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF808080),
          fontFamily: fontFamily,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF808080),
          fontFamily: fontFamily,
        ),
        iconColor: const Color(0xFF808080),
        labelStyle: MaterialStateTextStyle.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? const TextStyle(
                  color: Color(0xFF3F3F3F),
                  fontFamily: fontFamily,
                )
              : const TextStyle(
                  color: Color(0xFF808080),
                  fontFamily: fontFamily,
                ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 16,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFA81818),
        linearTrackColor: Color(0xFF3F3F3F),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(const Color(0xFFA81818)),
      ),
      scaffoldBackgroundColor: const Color(0xFF101010),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(
          const Color(0xFF3F3F3F),
        ),
        radius: const Radius.circular(8),
        thickness: MaterialStateProperty.all(6),
      ),
      shadowColor: const Color(0x3F000000),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: const Color(0xFFF34923),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      splashColor: const Color(0x08FFFFFF),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(const Color(0xFFF0F0F0)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 24,
        ),
        labelMedium: TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 14,
        ),
        titleMedium: TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 16,
        ),
        titleLarge: TextStyle(
          color: Color(0xFFF0F0F0),
          fontFamily: fontFamily,
          fontSize: 18,
        ),
      ),
      useMaterial3: true,
    );
  }
}

class SuccessThemeExtension extends ThemeExtension<SuccessThemeExtension> {
  const SuccessThemeExtension({this.success});

  final Color? success;

  @override
  ThemeExtension<SuccessThemeExtension> copyWith({Color? success}) =>
      SuccessThemeExtension(success: this.success ?? success);

  @override
  ThemeExtension<SuccessThemeExtension> lerp(
    ThemeExtension<SuccessThemeExtension>? other,
    double t,
  ) {
    if (other is! SuccessThemeExtension) return this;
    return SuccessThemeExtension(
      success: Color.lerp(success, other.success, t),
    );
  }
}
