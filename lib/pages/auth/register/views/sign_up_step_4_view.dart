import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/register/sign_up_controller.dart';
import 'package:locoo/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:locoo/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:locoo/pages/new_post/widgets/progress_line.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';

import '../../../new_post/widgets/circle_step.dart';

class SignUpStep4View extends StatelessWidget {
  const SignUpStep4View({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpController controller = Get.put(SignUpController());

    return AppBarBigView(
      title: 'Registrieren',
      showBackButton: false,
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
                CircleStep(1, '4', () {}),
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
              'Schritt 4 von 4',
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

            SizedBox(height: 20),

            BottomNavBar(controller: controller),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
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
            label: 'Veröffenlichen',
          )),
        ],
      ),
    );
  }
}
