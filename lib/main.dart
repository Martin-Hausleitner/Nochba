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
  // final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.DASHBOARD,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,

      //theme: AppTheme.light,
      // theme: theme.copyWith(
      //   scaffoldBackgroundColor: Colors.grey.shade100,
      //   highlightColor: Colors.transparent,
      //   splashColor: Colors.transparent,
      //   primaryColor: Color.fromARGB(255, 62, 146, 108),

      //   colorScheme: theme.colorScheme
      //       .copyWith(secondary: Color.fromARGB(255, 97, 167, 135)),
      //   textTheme: TextTheme(
      //     headlineLarge: GoogleFonts.inter(
      //         fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      //     bodyText1: GoogleFonts.inter(
      //         fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      //     bodyText2: GoogleFonts.inter(
      //         fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      //     button: GoogleFonts.inter(
      //       fontSize: 14,
      //       fontWeight: FontWeight.w500,
      //       letterSpacing: 1.25,
      //     ),
      //     caption: GoogleFonts.inter(
      //         fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      //     overline: GoogleFonts.inter(
      //         fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      //   ),
      // ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        primaryColor: Color.fromARGB(255, 62, 146, 108),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Color.fromARGB(255, 22, 22, 22),
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: Color.fromARGB(255, 22, 22, 22),
          ),
        ),
      ),

      //darkTheme: AppTheme.dark,
      //themeMode: ThemeMode.system,
    );
  }
}
