import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/register/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import '../../../new_post/widgets/circle_step.dart';

class SignUpStep3View extends StatelessWidget {
  const SignUpStep3View(
      {super.key, required this.controller, required this.onPressedBack});

  final SignUpController controller;
  final void Function() onPressedBack;

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
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
                CircleStep(1, '3', () {}),
                ProgressLine(
                  isFinished: false,
                ),
                CircleStep(2, '4', () {}),
              ],
            ),
            SizedBox(height: 28),
            //tile small Wähle deien Kategorie
            Text(
              'Gebe deinen Adresse ein',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            //tile small Schritt 1 von 3
            SizedBox(height: 2),
            Text(
              'Schritt 3 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: LocooTextField(
                    label: 'Sraße',
                    // controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: LocooTextField(
                    label: 'Nr.',
                    // controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            LocooTextField(
              label: 'Stadt',
              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),

            LocooTextField(
              label: 'Postleitzahl',
              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
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
