import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nochba/pages/private_profile/private_profile_page.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/cards/action_card_title.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/cards/action_text_card_red.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:math';

import 'package:confetti/confetti.dart';

import 'settings/manage_account_view.dart';

// Text(
//                 'Settings',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               SizedBox(height: 20),

// create a settings Page which have a list of rounded containers with a text and a icon on the left side with scaffold

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Einstellungen',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        ActionCardTitle(
          title: 'Konto',
        ),
        ActionCard(
          title: 'Konto verwalten',
          icon: FlutterRemix.user_line,
          onTap: () {
            Get.to(
              // routeName: 'test',
              // ManageAccountView(),
              fullscreenDialog: true,
              transition: Transition.cupertino,
              ManageAccountView(),
            );
          },
        ),

        ActionCard(
          title: 'Benachrichtigungen',
          icon: FlutterRemix.notification_2_line,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Sprache',
          icon: Icons.translate_rounded,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Erscheinungsbild',
          icon: FlutterRemix.contrast_2_line,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Hilfe',
          icon: FlutterRemix.question_line,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        // SizedBox(height: 25),
        ActionCardTitle(
          title: 'Inhalte & Aktivität',
        ),
        ActionCard(
          title: 'Datenschutzerklärung',
          icon: FlutterRemix.shield_user_line,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCardImpressum(
          onTap: () => {},
        ),
        ActionCard(
          title: 'Lizenzen',
          icon: FlutterRemix.stack_fill,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Über Uns',
          icon: FlutterRemix.group_line,
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        SizedBox(height: 30),

        SizedBox(height: 30),

        // Create a Center Text wih a love icon and a text of the current version of the app of the app
        MadebyAndVersion(),
        SizedBox(height: 15),
      ],
    );
  }
}

class MadebyAndVersion extends StatelessWidget {
  const MadebyAndVersion({
    Key? key,
  }) : super(key: key);

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //draw on tap confetti with Path drawStar(Size size) {

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              //align center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Made with ",
                  // add font size 12 and gray color
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Icon(
                  FlutterRemix.heart_3_fill,
                  color: Colors.red,
                  size: 14,
                ),
                Text(
                  " in Linz",
                  // add font size 12 and gray color
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 3),
            //display packageInfo.version in Text
            FutureBuilder<PackageInfo>(
              future: _getPackageInfo(),
              builder:
                  (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasError) {
                  return const Text('ERROR');
                } else if (!snapshot.hasData) {
                  return const Text('Loading...');
                }

                final data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Version: ${data.version} (${data.buildNumber})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              },
            ),

            // const Text(
            //   'Version 1.0.0',
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ActionCardImpressum extends StatelessWidget {
  final VoidCallback onTap;

  const ActionCardImpressum({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // add background color to the rounded container
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // return a rounded container with a icon on the left side and a text
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 14, bottom: 14),
                child: Row(
                  children: [
                    // Icon(
                    //   size: 22,
                    //   icon.icon,
                    //   // color: Theme.of(context).primaryColor,
                    //   // color: Colors.black87,
                    //   color: Colors.black,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 7,
                        right: 6,
                      ),
                      child: Text(
                        '§',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,

                              // letterSpacing: -0.1,
                            ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Impressum',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              // letterSpacing: -0.1,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // return a arrow icon
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Icon(
                  FlutterRemix.arrow_right_s_line,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
