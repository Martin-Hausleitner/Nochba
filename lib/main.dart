import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.DASHBOARD,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,
      //theme: AppTheme.light,
      theme: theme.copyWith(
        scaffoldBackgroundColor: Colors.grey.shade100,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        primaryColor: Color.fromARGB(255, 62, 146, 108),
        colorScheme: theme.colorScheme
            .copyWith(secondary: Color.fromARGB(255, 97, 167, 135)),
        textTheme: TextTheme(
          headline1: GoogleFonts.inter(
              fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          headline2: GoogleFonts.inter(
              fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          headline3:
              GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w400),
          headline4: GoogleFonts.inter(
              fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          //Poster Title
          headline5: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: Colors.black87),

          headline6: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          subtitle1: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          subtitle2: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyText1: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyText2: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          button: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.25,
              color: Colors.white),
          caption: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          overline: GoogleFonts.inter(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
      ),

      //darkTheme: AppTheme.dark,
      //themeMode: ThemeMode.system,
    );
  }
}
