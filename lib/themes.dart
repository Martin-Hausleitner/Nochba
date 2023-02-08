import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Theme {
  final ThemeData _darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.amber,
        disabledColor: Colors.grey,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red));

  final ThemeData _lightTheme = ThemeData(
      //
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        disabledColor: Colors.grey,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.pink));

  final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
        fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: GoogleFonts.inter(
        fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.inter(
        fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: GoogleFonts.inter(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}
