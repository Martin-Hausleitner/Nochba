
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/cards/action_card_title.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:package_info_plus/package_info_plus.dart';

// import 'package:confetti/confetti.dart';


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
    final Uri url = Uri.parse('http://nochba.at/');

    Future<void> _launchUrl() async {
      if (!await launchUrl(url)) {
        throw 'Could not launch $url';
      }
    }

    return AppBarBigView(
      title: 'Einstellungen',
      onPressed: () => {Get.back()},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        const ActionCardTitle(
          title: 'Konto',
        ),
        ActionCard(
          title: 'Konto verwalten',
          icon: FlutterRemix.user_line,
          onTap: () {
            // Get.to(
            //   // routeName: 'test',
            //   // ManageAccountView(),
            //   fullscreenDialog: true,
            //   transition: Transition.cupertino,
            //   ManageAccountView(),
            // );
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
            Get.snackbar(
                "Sprache wählen", "Aktuell kann nur Deutsch gewählt werden");
          },
        ),
        ActionCard(
          title: 'Erscheinungsbild',
          icon: FlutterRemix.contrast_2_line,
          onTap: () {
            Get.snackbar("Erscheinungsbild",
                "Es wird in der Zukunft ein Dark modus kommen");
          },
        ),
        ActionCard(
          title: 'Hilfe',
          icon: FlutterRemix.question_line,
          onTap: _launchUrl,
        ),
        // SizedBox(height: 25),
        const ActionCardTitle(
          title: 'Inhalte & Aktivität',
        ),
        ActionCard(
          title: 'Datenschutzerklärung',
          icon: FlutterRemix.shield_user_line,
          onTap: _launchUrl,
        ),
        ActionCardImpressum(
          onTap: _launchUrl,
        ),
        ActionCard(
          title: 'Lizenzen',
          icon: FlutterRemix.stack_fill,
          onTap: _launchUrl,
        ),
        ActionCard(
          title: 'Über Uns',
          icon: FlutterRemix.group_line,
          onTap: _launchUrl,
        ),
        const SizedBox(height: 30),

        const SizedBox(height: 30),

        // Create a Center Text wih a love icon and a text of the current version of the app of the app
        const MadebyAndVersion(),
        const SizedBox(height: 15),
      ],
    );
  }
}

class BuildNumberWidget extends StatelessWidget {
  const BuildNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPackageInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        PackageInfo packageInfo = snapshot.data as PackageInfo;
        return Text('Build number: ${packageInfo.buildNumber}');
      },
    );
  }

  Future<PackageInfo> _getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }
}

class MadebyAndVersion extends StatelessWidget {
  const MadebyAndVersion({
    Key? key,
  }) : super(key: key);

  // Future<PackageInfo> _getPackageInfo() {
  //   return PackageInfo.fromPlatform();
  // }

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
                const Icon(
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
            const SizedBox(height: 3),
            // display packageInfo.version in Text

            // FutureBuilder<PackageInfo>(
            //   future: _getPackageInfo(),
            //   builder:
            //       (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            //     if (snapshot.hasError) {
            //       return const Text('ERROR');
            //     } else if (!snapshot.hasData) {
            //       return const Text('Loading...');
            //     }

            //     final data = snapshot.data!;

            //     return Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Version: ${data.version} (${data.buildNumber})',
            //           style: Theme.of(context).textTheme.bodySmall,
            //         ),
            //       ],
            //     );
            //   },
            // ),
            // BuildNumberWidget(),
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
                      padding: const EdgeInsets.only(
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
                      padding: const EdgeInsets.only(left: 8),
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
