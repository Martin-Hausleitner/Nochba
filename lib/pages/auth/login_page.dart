import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:nochba/pages/auth/login_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

class LoginPage extends GetView<LoginController> {
  //final VoidCallback onClicked;
  const LoginPage({Key? key /*, required this.onClicked*/}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      tailingIcon: Icons.close,
      onPressed: controller.getBack,
      title: 'Anmelden',
      backgroundColor: Theme.of(context).backgroundColor,
      children: [
        if (kIsWeb)
          Column(
            //align center
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Text(
                'Locoo Beta',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              // add a body smaall text 'Die Beta ist noch in Entwicklung also sehr absolut nicht geeignet für die Produktion'
              Text(
                'Die Beta Version für die Webversion ist noch sehr unstable also treten viele Bugs auf',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 24),
            ],
          ),

        // if (kIsWeb) show a button to open the web version
        if (!kIsWeb)
          Column(
            //space between
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),

                  LocooTextField(
                    label: 'Email',
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 10),
                  LocooTextField(
                    label: 'Passwort',
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  NextElevatedButton(
                    rtl: true,
                    onPressed: controller.signIn,
                    icon: Icons.chevron_left_outlined,
                    label: 'Anmelden',
                  ),
                  SizedBox(height: 10),

                  //add a small text 'Passwort vergessen'
                  Align(
                    //align left
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Passwort vergessen?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                  SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: //peddign left right 10
                            const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'oder',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                      )),
                    ],
                  ),
                  SizedBox(height: 25),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      primary: Theme.of(context).colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // splashFactory: InkRipple.splashFactory,
                      // enableFeedback: true,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/google_g_logo.svg',
                      width: 38,
                    ),
                    label: Text(
                      'Mit Google anmelden',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.07,
                          ),
                    ),
                    onPressed: () {
                      // controller.jumpBack();
                      // controller.previousPage();
                      // HapticFeedback.lightImpact();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: //open snackbar
                        () {},
                    //right icon posission

                    icon: Padding(
                      padding: //right 10
                          const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/icons/apple_logo.svg',
                        color: Theme.of(context).colorScheme.background,
                        width: 20,
                      ),
                    ),

                    //   SvgPicture.network(
                    // 'https://www.svgrepo.com/download/303552/google-g-2015-logo.svg',
                    // semanticsLabel: 'A shark?!',
                    // width: 38,
                    // placeholderBuilder: (BuildContext context) => Container(
                    //     padding: const EdgeInsets.all(30.0),
                    //     child: const CircularProgressIndicator()),
                    // ),

                    label: Text(
                      'Mit Apple anmelden',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.onPrimary,
                            letterSpacing: -0.07,
                          ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
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
                  ),
                ],
              ),
              SizedBox(height: 20),
              /*RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    text: 'No Account? ',
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = onClicked,
                          text: 'Sign Up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.secondary,
                          ))
                    ]),
              ),*/
            ],
          ),
      ],
    );
  }
}

class NextElevatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool rtl;
  const NextElevatedButton({
    Key? key,
    //required this.controller,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.rtl = false,
  }) : super(key: key);

  //final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        //right icon posission

        icon: Icon(icon),
        label: Text(
          label,
          style: Theme.of(context).textTheme.button?.copyWith(
                color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                letterSpacing: -0.07,
              ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(60),
          shadowColor: Colors.transparent,
          // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
