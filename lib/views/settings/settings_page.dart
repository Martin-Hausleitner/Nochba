import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'settings/logout_settings_cart.dart';
import 'settings/settings_card.dart';

// Text(
//                 'Settings',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               SizedBox(height: 20),

// create a settings Page which have a list of rounded containers with a text and a icon on the left side with scaffold

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navTitleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            navLargeTitleTextStyle: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
          barBackgroundColor: Theme.of(context).backgroundColor),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          // A list of sliver widgets.
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              // padding: EdgeInsetsDirectional.only(
              //   start: 7,
              //   end: 23,
              // ),

              // leading: Icon(CupertinoIcons.person_2),
              // This title is visible in both collapsed and expanded states.
              // When the "middle" parameter is omitted, the widget provided
              // in the "largeTitle" parameter is used instead in the collapsed state.
              largeTitle: Text(
                'Einstellungen',
              ),
              leading: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    FlutterRemix.arrow_left_line,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              // padding left 10
              padding: EdgeInsetsDirectional.only(
                start: 12,
                end: 10,
              ),

              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // add a Silverlist with SettingsCard
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      'Konto',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SettingsCard(
                    title: 'Profil bearbeiten',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      Get.snackbar("Presed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Benachrichtigungen',
                    icon: Icon(FlutterRemix.notification_2_line),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Sprache',
                    icon: Icon(
                      Icons.translate_rounded,
                    ),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Erscheinungsbild',
                    icon: Icon(FlutterRemix.contrast_2_line),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Hilfe',
                    icon: Icon(FlutterRemix.question_line),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Inhalte & Aktivität',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SettingsCard(
                    title: 'Datenschutzerklärung',
                    icon: Icon(FlutterRemix.shield_user_line),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Impressum',
                    icon: Icon(FlutterRemix.dashboard_2_fill),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Lizenzen',
                    icon: Icon(FlutterRemix.stack_fill),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SettingsCard(
                    title: 'Über Uns',
                    icon: Icon(FlutterRemix.group_line),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SizedBox(height: 30),
                  LogoutSettingsCard(
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SizedBox(height: 30),

                  // Create a Center Text wih a love icon and a text of the current version of the app of the app
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          //align center
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Made with ",
                              // add font size 12 and gray color
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Icon(
                              FlutterRemix.heart_3_fill,
                              color: Colors.red,
                              size: 14,
                            ),
                            Text(
                              " in Linz",
                              // add font size 12 and gray color
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
