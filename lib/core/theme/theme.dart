import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static const Color primaryColor = Color(0xFF5CACEE);
  static const Color backgroundColor = Color(0xFFF6F7F9);
  static const Color textColor = Color(0xFF4D4D4D);
  static const Color greyColor = Color(0xFFB8B8B8);
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color brightYellow = Color(0xFFFFFC00);
  static const Color softGreen = Color(0xFF8BC34A);
  static const Color paleBlue = Color(0xFFADD8E6);
  static const Color dustyRose = Color(0xFFCFC1B7);
  static const Color mutedTeal = Color(0xFF90A4AE);
  static const Color softCoral = Color(0xFFFFC0CB);
  static const Color paleYellow = Color(0xFFFFF8DC);
  static const Color peachyPink = Color(0xFFFFDAB9);
  static const Color lightGrey = Color(0xFFD3D3D3);
  static const Color beige = Color(0xFFF5F5DC);

  static final ThemeData lightTheme = ThemeData(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: peachyPink,
      contentTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    backgroundColor: backgroundColor,
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: Colors.white,
      background: backgroundColor,
      surface: Colors.white,
      brightness: Brightness.light,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: primaryColor,
      onBackground: textColor,
      onSurface: textColor,
      onError: Colors.white,
      tertiary: paleBlue,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: TextTheme(
      headline1: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headline2: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headline3: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      headline4: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      bodyText1: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyText2: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: greyColor,
      ),
      subtitle1: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      subtitle2: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      button: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: primaryColor),
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    ),
  );
}
