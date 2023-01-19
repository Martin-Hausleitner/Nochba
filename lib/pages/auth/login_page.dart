import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:nochba/pages/auth/login_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

class LoginPage extends GetView<LoginController> {
  //final VoidCallback onClicked;
  const LoginPage({Key? key /*, required this.onClicked*/}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      tailingIcon: Icons.close_rounded,
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
                'Nochba Beta',
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
                  PasswordField(controller: controller),
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
                    child: GestureDetector(
                      //write a alert which said in german that you must write a email to project@nochba.com
                      onTap: () {
                        Get.snackbar(
                          'Passwort vergessen',
                          'Schreibe eine Email an project@nochba.com mit deiner Email Adresse und wir senden dir ein neues Passwort!',
                          // snackPosition: SnackPosition.BOTTOM,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          colorText: Theme.of(context).colorScheme.onSurface,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          isDismissible: false,
                          //form bottom to top
                          duration: const Duration(seconds: 10),
                          // isDismissible: true,
                          forwardAnimationCurve: Curves.easeOut,
                          reverseAnimationCurve: Curves.easeIn,
                          animationDuration: const Duration(milliseconds: 500),
                          icon: Icon(
                            Icons.info_outline_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          shouldIconPulse: true,
                          mainButton: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        );
                      },

                      child: Text(
                        'Passwort vergessen?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
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
                      // backgroundColor:
                      //     Theme.of(context).colorScheme.onBackground,
                      elevation: 0,
                      backgroundColor: Colors.black,
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

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LoginController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return LocooTextField(
      obscureText: _isObscure,
      label: 'Passwort',
      suffixIcon: Padding(
        padding: const EdgeInsets.only(top: 9, left: 2),
        child: LocooCircularIconButton(
          iconData: _isObscure ? Icons.visibility : Icons.visibility_off,
          // fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          //fill color transparent
          fillColor: Colors.transparent,
          iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          radius: 24,
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      // suffixIcon: IconButton(
      //   icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
      //   onPressed: () {
      //     setState(() {
      //       _isObscure = !_isObscure;
      //     });
      //   },
      // ),
      controller: widget.controller.passwordController,
      // validator: widget.controller.validatePassword,
      autovalidateMode: AutovalidateMode.disabled,
      textInputAction: TextInputAction.done,
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
