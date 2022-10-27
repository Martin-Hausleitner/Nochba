import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/register/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpEmailView extends StatelessWidget {
  const SignUpEmailView({super.key});

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
              'Schritt 4 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            SizedBox(height: 28),
            LocooTextField(
              label: 'Email',

              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),

            LocooTextField(
              label: 'Passwort',
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            Padding(
              padding: // right left 5
                  EdgeInsets.only(
                top: 15,
                left: 7,
                right: 7,
              ),
              child: Row(
                //spacebetween
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Flexible(
                    child: Text(
                      'Ich Akzeptiere die Nutzungsbedingungen und Datenschutzbestimmungen',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6)),
                    ),
                  ),
                  SizedBox(width: 10),

                  //show a checkbox
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
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
