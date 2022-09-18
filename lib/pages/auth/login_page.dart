import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
import 'package:locoo/pages/auth/signUp_page.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';

class LoginPage extends GetView<AuthController> {
  final VoidCallback onClicked;
  const LoginPage({Key? key, required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return AppBarBigView(
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
                  TextFormField(
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NextElevatedButton(
                    rtl: true,
                    onPressed: controller.signIn,
                    icon: Icons.chevron_left_outlined,
                    label: 'Anmelden',
                    controller: controller,
                  ),
                  SizedBox(height: 20),
                  // OutlinedButton(
                  //   style: OutlinedButton.styleFrom(
                  //     minimumSize: const Size.fromHeight(60),
                  //     primary: Theme.of(context).colorScheme.onSurface,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     // splashFactory: InkRipple.splashFactory,
                  //     // enableFeedback: true,
                  //   ),
                  //   child: Text(
                  //     'Regestrieren',
                  //     style: Theme.of(context).textTheme.button?.copyWith(
                  //           color: Theme.of(context).colorScheme.onSurface,
                  //           letterSpacing: -0.07,
                  //         ),
                  //   ),
                  //   //onPRessed signup PAge
                  //   onPressed: () {
                  //     //get.to signuppage
                  //     Get.to(() => SignUpPage(
                  //           onClicked: onClicked,
                  //         ));
                  //   },
                  // ),
                  RichText(
                    text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                        text: 'No Account? ',
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = onClicked,
                              text: 'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.secondary,
                              ))
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: 260,
              ),
              LocooTextButton(
                label: 'Erstelle einen Demo Accountd',
                onPressed: () async => controller.createDemoAccount(),
                icon: Icons.login,
              ),
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
    required this.controller,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.rtl = false,
  }) : super(key: key);

  final AuthController controller;

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
