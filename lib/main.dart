import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:nochba/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/src/material_localizations.dart';
import 'package:flutter_localizations/src/cupertino_localizations.dart';
import 'package:flutter_localizations/src/widgets_localizations.dart';
import 'package:nochba/pages/private_profile/views/settings/language_selector_view.dart';
import 'package:provider/provider.dart';
import 'logic/commonbase/util.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
// import 'themes/app_theme.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //     // webRecaptchaSiteKey: 'recaptcha-v3-site-key',  // If you're building a web app.
  //     );
  // await dotenv.load();
  // await dotenv.load(mergeWith: Platform.environment);
  _downloadInitialLanguageModels();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //       statusBarColor: Colors.transparent,
  //       systemNavigationBarColor: Colors.white,
  //       systemNavigationBarIconBrightness: Brightness.dark),
  // );

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

  runApp(BetterFeedback(child: MyApp(theme: theme)));
  // runApp(MyApp());
}

Future<void> _downloadInitialLanguageModels() async {
  final _modelManager = OnDeviceTranslatorModelManager();
  await _modelManager.downloadModel('en');
  await _modelManager.downloadModel('de');
}

class MyApp extends StatefulWidget {
  // final ThemeData theme = ThemeData();
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final localeProvider = Provider.of<LocaleProvider>(context);
        return GetMaterialApp(
          initialRoute: AppRoutes.HOME,
          getPages: AppPages.list,
          debugShowCheckedModeBanner: false,
          theme: widget.theme,

          // Translation
          locale: localeProvider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],

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
      });
}
