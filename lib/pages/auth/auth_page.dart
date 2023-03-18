import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/login_page.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import 'sign_up_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isDialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadDialogState();
  }

  void _loadDialogState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDialogShown', true);

    setState(() {
      _isDialogShown = prefs.getBool('isDialogShown') ?? false;
    });
    if (!_isDialogShown) {
      _isDialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            icon: Lottie.asset(
              'assets/lottie/shake.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            title: Text(
              "Early Access",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            content: Text(
              "Diese App befindet sich im Early Access. Wenn Sie auf Fehler, Bugs oder andere Probleme stoßen, schütteln Sie bitte Ihr Handy. Dadurch wird ein Feedback-Menü geöffnet, über das Sie den Fehler melden können.",
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text(
                    "LOS GEHT'S!",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onSurface: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    _saveDialogState();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _saveDialogState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDialogShown', true);
  }

  final controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/auth_page_background.jpg'), // <-- BACKGROUND IMAGE
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //a white icon button align left

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kDebugMode)
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () async =>
                                  controller.createDemoAccount(),
                              icon: const Icon(
                                FlutterRemix.user_add_line,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: //top 20 left 12
                          const EdgeInsets.only(top: 100, left: 12, right: 12),
                      child: Column(
                        //align start
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Willkommen in',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  letterSpacing: -0.4,
                                  color: Colors.white,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                'deiner ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30,
                                      letterSpacing: -0.4,
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                'Nochba',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 30,
                                      letterSpacing: -0.4,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              Text(
                                'schaft',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                      letterSpacing: -0.4,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // show a container

                Container(
                  // height: 140,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // LocooTextButton(
                        //   label: 'Anmelden',
                        //   icon: Icons.login,
                        //   onPressed: () async =>
                        //       {await Get.to(() => const LoginPage())},
                        // ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSurface,
                              minimumSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // splashFactory: InkRipple.splashFactory,
                              // enableFeedback: true,
                            ),
                            child: Text(
                              'Anmelden',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: -0.07,
                                  ),
                            ),
                            // onPressed: () async =>
                            //     {await Get.to(() => const LoginPage())},
                            // onPressed: () => const LoginPage(),

                            onPressed: () async => {
                                  await Get.to(() => const LoginPage()),
                                }),

                        // set the width and height

                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       title: const Text(
                        //           "Warnung vor Datenverlust: Bitte beachten Sie, dass alle während der Testphase eingegebenen Daten verloren gehen können"),
                        //       content: const Text(
                        //           "Wir möchten Sie daran erinnern, dass alle während der Testphase in die App eingegebenen Daten nach Abschluss der Testphase verloren gehen können. Wir freuen uns sehr über Ihr Feedback, um die App für künftige Nutzer zu verbessern. Wir bitten Sie, uns unter project@nochba.com zu kontaktieren, wenn Sie Fehler oder Probleme mit den Funktionen der App feststellen. Wir danken für Ihr Verständnis und wünschen Ihnen viel Spaß mit der App!"),
                        //       actions: [
                        //         TextButton(
                        //           child: const Text("LOS GEHT'S!"),
                        //           onPressed: () async => {
                        //             await Get.to(
                        //               () => const LoginPage(),
                        //               transition: Transition.rightToLeft,
                        //             ),
                        //             //close dialog
                        //             Navigator.of(context).pop(),
                        //           },
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                        // }),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: () async => {
                            await Get.to(
                              () => const NewSignUpPage(),
                              transition: Transition.leftToRight,
                              // gestureWidth: 100,
                            )
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: const Size.fromHeight(60),
                            shadowColor: Colors.transparent,
                            // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          child: Text(
                            'Registrieren',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.onPrimary,
                                  letterSpacing: -0.07,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
