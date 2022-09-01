import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/pages/private_profile/private_profile_page.dart';
import 'package:locoo/shared/ui/cards/action_card.dart';
import 'package:locoo/shared/ui/cards/action_card_title.dart';
import 'package:locoo/shared/ui/cards/action_text_card.dart';
import 'package:locoo/shared/ui/cards/action_text_card_red.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:math';

import 'package:confetti/confetti.dart';

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
      children: [
        ActionCardTitle(
          title: 'Konto',
        ),
        ActionCard(
          title: 'Konto verwalten',
          icon: Icon(FlutterRemix.user_line),
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
          icon: Icon(FlutterRemix.notification_2_line),
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Sprache',
          icon: Icon(
            Icons.translate_rounded,
          ),
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Erscheinungsbild',
          icon: Icon(FlutterRemix.contrast_2_line),
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Hilfe',
          icon: Icon(FlutterRemix.question_line),
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
          icon: Icon(FlutterRemix.shield_user_line),
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCardImpressum(
          onTap: () => {},
        ),
        ActionCard(
          title: 'Lizenzen',
          icon: Icon(FlutterRemix.stack_fill),
          onTap: () {
            Get.snackbar("Pressed", "Pressed");
          },
        ),
        ActionCard(
          title: 'Über Uns',
          icon: Icon(FlutterRemix.group_line),
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

class ManageAccountView extends StatelessWidget {
  const ManageAccountView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Konto Verwalten',
      children: [
        ActionTextCard(
          title: 'Email',
          icon: Icon(FlutterRemix.user_line),
          onTap: () {},
          text: 'Test@test.at',
        ),
        ActionTextCard(
          title: 'Passwort',
          icon: Icon(FlutterRemix.user_line),
          onTap: () {},
          text: '⦁⦁⦁⦁⦁⦁⦁⦁⦁',
        ),
        ActionTextCard(
          title: 'Adresse',
          icon: Icon(FlutterRemix.user_line),
          onTap: () {},
          text: 'Gutenbergstraße 1, 1234 Wien',
        ),
        SizedBox(height: 30),
        ActionTextCardRed(
          title: 'Account löschen',
          icon: Icon(FlutterRemix.user_line),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialogDeleteAccount(),
          ),
          text: '',
        ),
      ],
    );
  }
}

class AlertDialogDeleteAccount extends StatelessWidget {
  const AlertDialogDeleteAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        //add round corner 20
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          //align center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add a red icon flutterremix error-warning-line
            Icon(
              FlutterRemix.error_warning_line,
              // color: Theme.of(context).colorScheme.error,
              color: Colors.red,
              size: 40,
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'Account löschen',
              //add fontwiehgt w500
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          'Lösche deinen Account für immer bei Locoo. Die Daten können nicht wiederhergestellt werden.',
          //style the text gray
          style: TextStyle(color: Color.fromARGB(133, 36, 36, 36)),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Abbrechen'),
                  child: const Text('Abbrechen'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Löschen'),
                  //style the button red
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                    // add round corner 20
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
                    Text('App Name: ${data.appName}'),
                    Text('Package Name: ${data.packageName}'),
                    Text('Version: ${data.version}'),
                    Text('Build Number: ${data.buildNumber}'),
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
