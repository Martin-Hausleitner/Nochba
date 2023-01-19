import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:lottie/lottie.dart';

import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpVerifiedView extends StatelessWidget {
  const SignUpVerifiedView(
      {super.key, required this.controller, required this.onPressedBack});

  final SignUpController controller;
  final void Function() onPressedBack;

  @override
  Widget build(BuildContext context) {
    List<int> value = [2];
    List<S2Choice<int>> frameworks = [
      S2Choice<int>(value: 1, title: 'Ionic'),
      S2Choice<int>(value: 2, title: 'Flutter'),
      S2Choice<int>(value: 3, title: 'React Native'),
    ];

    return AppBarBigView(
        tailingIcon: Icons.close_rounded,
        title: 'Registrieren',
        onPressed: onPressedBack,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleStep(3, '1', () {}),
                  ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(3, '2', () {}),
                  ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(3, '3', () {}),
                  ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(3, '4', () {}),
                ],
              ),
              SizedBox(height: 28),
              //tile small Wähle deien Kategorie
              Text(
                'Wähle deine Authoezierungs Methode aus',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
              //tile small Schritt 1 von 3
              SizedBox(height: 2),
              Text(
                'Schritt 4 von 4',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // fontSize: 18,
                    // fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
              SizedBox(height: 28),
              Container(
                // color: Colors.red,
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/success.json',
                    height: 200,
                    fit: BoxFit.cover,
                    repeat: false,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Erfolgreich Verifiziert',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Du hast dich erfolgreich Verifiziert, du kannst jetzt mit deinen Nachbarn connecten!',
                  //align center
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      // fontSize: 18,
                      // fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Column(
              //     children: [
              //       BackOutlinedButton(
              //         controller: controller,
              //         icon: FlutterRemix.pencil_line,
              //         label: "Post Bearbeiten",
              //       ),
              //       SizedBox(height: 5),
              //       NextElevatedButton(
              //         onPressed: //controller.addPost() and go to
              //             () {
              //           controller.addPost();
              //           controller.jumpToPage(4);
              //           // Get.to(PublishedNewPostView());
              //         },
              //         controller: controller,
              //         icon: FlutterRemix.home_2_line,
              //         label: 'Zurück zum Feed',
              //       ),
              //     ],
              //   ),
              SizedBox(height: 40),
              NextElevatedButton(
                rtl: true,
                onPressed: //controller.addPost() and go to
                    () async {
                  await controller.signUp();
                  //close keyboard
                  FocusScope.of(context).unfocus();
                  // Get.to(PublishedNewPostView());
                },
                controller: controller,
                icon: Icons.chevron_left_outlined,
                label: 'Los gehts',
              ),
            ],
          )
        ]);
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BackOutlinedButton(
            controller: controller,
            icon: Icons.chevron_left_rounded,
            label: 'Zurück',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: NextElevatedButton(
            rtl: true,
            onPressed: //controller.addPost() and go to
                () {
              controller.nextPage();
              //close keyboard
              FocusScope.of(context).unfocus();
              // Get.to(PublishedNewPostView());
            },
            controller: controller,
            icon: Icons.chevron_left_outlined,
            label: 'Weiter',
          ),
        ),
      ],
    );
  }
}

enum SingingCharacter { location, qrcode }

class ChooserRadio extends StatefulWidget {
  const ChooserRadio({super.key});

  @override
  State<ChooserRadio> createState() => _ChooserRadioState();
}

class _ChooserRadioState extends State<ChooserRadio> {
  SingingCharacter? _character = SingingCharacter.location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _character = SingingCharacter.location;
            });
          },
          child: Container(
            height: 90,
            // add background color to the rounded container
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                // a listtile ein a gray round box
                Center(
              child: ListTile(
                title: Row(
                  children: [
                    //Email icon
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                          size: 40,
                          Icons.near_me_outlined,
                          // color: Colors.black.withOpacity(0.2)),
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text('Verifiziere dich mit deinen Standort')),
                  ],
                ),
                trailing: Radio<SingingCharacter>(
                  value: SingingCharacter.location,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _character = SingingCharacter.qrcode;
            });
          },
          child: Container(
            height: 90,
            // add background color to the rounded container
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //center align

                  children: [
                    //Email icon
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                          size: 40,
                          // gr code
                          Icons.qr_code_scanner_outlined,
                          // color: Colors.black.withOpacity(0.2)),
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verfiziere dich mit einem QR Code',
                      ),
                    ),
                  ],
                ),
                trailing: Radio<SingingCharacter>(
                  activeColor: Theme.of(context).primaryColor,
                  value: SingingCharacter.qrcode,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
