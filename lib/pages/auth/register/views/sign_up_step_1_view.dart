import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpStep1View extends StatelessWidget {
  const SignUpStep1View({super.key, required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    // bool _isObscure = true;

    return AppBarBigView(
        tailingIcon: Icons.close_rounded,
        onPressed: () async => await controller.quitRegistration(),
        title: 'Register',
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleStep(1, '1', () {}),
                  const ProgressLine(
                    isFinished: false,
                  ),
                  CircleStep(2, '2', () {}),
                  const ProgressLine(
                    isFinished: false,
                  ),
                  CircleStep(2, '3', () {}),
                  const ProgressLine(
                    isFinished: false,
                  ),
                  CircleStep(2, '4', () {}),
                ],
              ),
              const SizedBox(height: 28),
              //tile small Wähle deien Kategorie
              Text(
                'Enter the email and password',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
              //tile small Schritt 1 von 3
              const SizedBox(height: 2),
              Text(
                'Schritt 1 von 4',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // fontSize: 18,
                    // fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
              const SizedBox(height: 28),
              Form(
                key: controller.formKey1,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    LocooTextField(
                      label: 'Email',
                      controller: controller.emailController,
                      validator: controller.validateEmail,
                      autovalidateMode: AutovalidateMode.disabled,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    PasswordField(controller: controller),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 20),
              NextElevatedButton(
                rtl: true,
                onPressed: //controller.addPost() and go to
                    () async {
                  await controller.nextPage();
                  FocusScope.of(context).unfocus();
                  // Get.to(PublishedNewPostView());
                },
                controller: controller,
                icon: Icons.chevron_left_outlined,
                label: 'Weiter',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: //peddign left right 10
                        const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'oder',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                    ),
                  ),
                  const Expanded(
                      child: Divider(
                    thickness: 1,
                  )),
                ],
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  minimumSize: const Size.fromHeight(60),
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
                  'Mit Google registrieren',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.07,
                      ),
                ),
                onPressed: () async {
                  // Get.snackbar(
                  //   'Bald Verfügbar',
                  //   'Die Registrierung mit Google ist bald verfügbar!',
                  //   // snackPosition: SnackPosition.BOTTOM,
                  //   backgroundColor: Theme.of(context).colorScheme.background,
                  //   colorText: Theme.of(context).colorScheme.onSurface,
                  //   margin: const EdgeInsets.all(16),
                  //   borderRadius: 12,
                  //   isDismissible: false,
                  //   //form bottom to top
                  //   duration: const Duration(seconds: 10),
                  //   // isDismissible: true,
                  //   forwardAnimationCurve: Curves.easeOut,
                  //   reverseAnimationCurve: Curves.easeIn,
                  //   animationDuration: const Duration(milliseconds: 500),
                  //   icon: Icon(
                  //     Icons.info_outline_rounded,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  //   shouldIconPulse: true,
                  //   mainButton: TextButton(
                  //     onPressed: () {
                  //       Get.back();
                  //     },
                  //     child: Text(
                  //       'OK',
                  //       style: TextStyle(
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     ),
                  //   ),
                  // );
                  try {
                    await controller.signUpWithGoogle();
                  } catch (error) {
                    print('Google Sign In Error: $error');
                    // Show an error message to the user
                    Get.snackbar('Error',
                        'Google Sign In failed. Please try again later.');
                  }
                },
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Bald Verfügbar',
                    'Die Registrierung mit Apple ist bald verfügbar!',
                    // snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Theme.of(context).colorScheme.background,
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
                  // await controller.signInWithApple();
                },

                icon: Padding(
                  padding: //right 10
                      const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/icons/apple_logo.svg',
                    color: Theme.of(context).backgroundColor,
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
                  'Mit Apple registrieren',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme
                            ?.onPrimary,
                        letterSpacing: -0.07,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Theme.of(context).colorScheme.onBackground,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(60),
                  shadowColor: Colors.transparent,
                  // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                  //background color red
                  backgroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),

              // BottomNavBar(controller: controller),
            ],
          )
        ]);
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SignUpController controller;

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
      validator: widget.controller.validatePassword,
      autovalidateMode: AutovalidateMode.disabled,
      textInputAction: TextInputAction.done,
    );
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
          onPressed: //controller.addPost() and go to
              () {
            //first page:
            controller.goToPage(0);
            //controller.jumpToPage(4);
            //close keyboard
            FocusScope.of(context).unfocus();
            // Get.to(PublishedNewPostView());
          },
          controller: controller,
          icon: Icons.done_outlined,
          label: 'Regestrieren',
        )),
      ],
    );
  }
}
