import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/register/sign_up_controller.dart';
import 'package:locoo/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:locoo/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:locoo/pages/new_post/widgets/progress_line.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';

import '../../../new_post/widgets/circle_step.dart';

class SignUpStep1View extends StatelessWidget {
  const SignUpStep1View({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpController controller = Get.put(SignUpController());

    return AppBarBigView(
      title: 'Registrieren',
      // showBackButton: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleStep(1, '1', () {}),
                ProgressLine(
                  isFinished: false,
                ),
                CircleStep(2, '2', () {}),
                ProgressLine(
                  isFinished: false,
                ),
                CircleStep(2, '3', () {}),
                ProgressLine(
                  isFinished: false,
                ),
                CircleStep(2, '4', () {}),
              ],
            ),
            SizedBox(height: 28),
            //tile small Wähle deien Kategorie
            Text(
              'Gebe deine Email und Passwort ein',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            //tile small Schritt 1 von 3
            SizedBox(height: 2),
            Text(
              'Schritt 1 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            SizedBox(height: 28),
            TextFormField(
              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 10),

            TextFormField(
              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Passwort',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 10),

            SizedBox(height: 20),
            NextElevatedButton(
              rtl: true,
              onPressed: //controller.addPost() and go to
                  () {
                controller.goToPage(1);
                FocusScope.of(context).unfocus();
                // Get.to(PublishedNewPostView());
              },
              controller: controller,
              icon: Icons.chevron_left_outlined,
              label: 'Weiter',
            ),
            SizedBox(height: 20),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                )),
              ],
            ),
            SizedBox(height: 20),

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
                'Mit Google registrieren',
                style: Theme.of(context).textTheme.button?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.07,
                    ),
              ),
              onPressed: () {
                // controller.jumpBack();
                controller.previousPage();
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
                'Mit Apple registrieren',
                style: Theme.of(context).textTheme.button?.copyWith(
                      color:
                          Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                      letterSpacing: -0.07,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                elevation: 0,
                minimumSize: const Size.fromHeight(60),
                shadowColor: Colors.transparent,
                // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
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
      ],
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
            icon: FlutterRemix.arrow_left_s_line,
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
