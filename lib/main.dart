import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'logic/commonbase/util.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
// import 'themes/app_theme.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //     // webRecaptchaSiteKey: 'recaptcha-v3-site-key',  // If you're building a web app.
  //     );

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  GetTimeAgo.setCustomLocaleMessages('de', DEMessage());
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // load cloud functions 
  FirebaseFunctions.instance;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
//  PlatformDispatcher.instance.onError = (error, stack) {
//    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//    return true;
//  };

  runApp(MyApp(theme: theme));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final ThemeData theme = ThemeData();
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,
      theme: theme,

      // theme: AppTheme.light,
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
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.grey.shade100,
      //   highlightColor: Colors.transparent,
      //   splashColor: Colors.transparent,
      //   primaryColor: Color.fromARGB(255, 62, 146, 108),
      //   fontFamily: 'Inter',
      //   cardColor: Color.fromARGB(255, 245, 245, 245),
      //   // textTheme: TextTheme(
      //   //   headlineLarge: GoogleFonts.inter(
      //   //     fontSize: 24,
      //   //     fontWeight: FontWeight.w700,
      //   //     letterSpacing: -0.5,
      //   //     color: Color.fromARGB(255, 22, 22, 22),
      //   //   ),
      //   //   titleLarge: GoogleFonts.inter(
      //   //     fontSize: 24,
      //   //     fontWeight: FontWeight.w800,
      //   //     letterSpacing: -0.5,
      //   //     color: Color.fromARGB(255, 22, 22, 22),
      //   //   ),
      //   //   titleMedium: GoogleFonts.inter(
      //   //     fontSize: 22,
      //   //     fontWeight: FontWeight.w700,
      //   //     letterSpacing: -0.5,
      //   //   ),
      //   //   headlineMedium: GoogleFonts.inter(
      //   //     fontSize: 14,
      //   //     fontWeight: FontWeight.w600,
      //   //     letterSpacing: -0.5,
      //   //     color: Color.fromARGB(255, 22, 22, 22),
      //   //   ),
      //   //   bodySmall: GoogleFonts.inter(
      //   //     fontSize: 14,
      //   //     fontWeight: FontWeight.w400,
      //   //     letterSpacing: -0.1,
      //   //     color: Color.fromARGB(255, 66, 66, 66),
      //   //   ),
      //   //   titleSmall: GoogleFonts.inter(
      //   //     fontSize: 14,
      //   //     fontWeight: FontWeight.w600,
      //   //     letterSpacing: -0.1,
      //   //     color: Color.fromARGB(255, 112, 112, 112),
      //   //     // set it uppercase
      //   //   ),
      //   //   bodyMedium: GoogleFonts.inter(
      //   //     fontSize: 14,
      //   //     fontWeight: FontWeight.w500,
      //   //     letterSpacing: -0.1,
      //   //     color: Color.fromARGB(255, 34, 34, 34),
      //   //   ),
      //   // ),
      // ),

      //darkTheme: AppTheme.dark,
      //themeMode: ThemeMode.system,
    );
  }
}
