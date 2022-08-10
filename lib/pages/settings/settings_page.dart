import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/settings/settings/logout_settings_cart.dart';
import 'package:locoo/pages/settings/settings/settings_card.dart';

import '../feed/post/category_badge.dart';
import '../feed/post/post.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        title:
            const Text('Einstellungen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            FlutterRemix.arrow_left_line,
            color: Colors.black,
          ),
          //onPress open SettingsPage
          // got back to he previes screen
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: // add colum with a titleLarge text and a list of rounded containers with a text and a icon on the left side
          Container(
        child: Column(
          // allign left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // add a expended then a lsitview
            Expanded(
              child: ListView(
                // add a list of rounded containers with a text and a icon on the left side
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
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

            //create a list view
            // create a list view with a text

            // add listview with a a gray rounded container with a text and a icon on the left side
          ],
        ),
      ),
    );
  }
}
