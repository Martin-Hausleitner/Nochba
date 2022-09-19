import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/register/sign_up_controller.dart';
import 'package:locoo/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:locoo/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:locoo/pages/new_post/widgets/progress_line.dart';
import 'package:locoo/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';

import '../../../new_post/widgets/circle_step.dart';

class SignUpStep2View extends StatelessWidget {
  const SignUpStep2View({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpController controller = Get.put(SignUpController());

    return AppBarBigView(
      title: 'Registrieren',
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
                CircleStep(1, '2', () {}),
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
              'Gebe deinen Namen und ein Profilbild ein',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            //tile small Schritt 1 von 3
            SizedBox(height: 2),
            Text(
              'Schritt 2 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            SizedBox(height: 25),
            // Center(
            //   child: Stack(
            //     clipBehavior: Clip.none,
            //     alignment: Alignment.bottomRight,
            //     children: [
            //       // LocooCircularIconButton(
            //       //   iconData: FlutterRemix.pencil_line,
            //       //   fillColor: Theme.of(context).primaryColor,
            //       //   iconColor: Colors.white,
            //       //   radius: 32,
            //       //   onPressed: () => Navigator.pop(context),
            //       // ),
            //       CircleAvatar(
            //         backgroundColor: Colors.black26,
            //         radius: 55,
            //         backgroundImage: NetworkImage(
            //           "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
            //         ),
            //       ),
            //       SizedBox(
            //         height: 30.0,
            //         width: 30.0,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: Theme.of(context).primaryColor,
            //             borderRadius: BorderRadius.all(Radius.circular(100)),
            //           ),
            //           child: IconButton(
            //             color: Theme.of(context).primaryColor,
            //             padding: EdgeInsets.zero,
            //             splashRadius: 1,
            //             iconSize: 30 / 2 + 3,
            //             icon: Icon(FlutterRemix.pencil_line,
            //                 color: Theme.of(context).canvasColor),
            //             // splashColor: Colors.red,
            //             onPressed: //open image picker
            //                 () {},
            //           ),
            //         ),
            //       ),
            //       // Ink(
            //       //   width: 32,
            //       //   height: 32,
            //       //   decoration: ShapeDecoration(
            //       //     color: Theme.of(context).primaryColor,
            //       //     shape: CircleBorder(
            //       //         side: BorderSide(color: Colors.transparent)),
            //       //   ),
            //       //   child: IconButton(
            //       //     color: Theme.of(context).primaryColor,
            //       //     padding: EdgeInsets.zero,
            //       //     splashRadius: 32 / 2,
            //       //     iconSize: 32 / 2 + 3,
            //       //     icon: Icon(FlutterRemix.pencil_line,
            //       //         color: Theme.of(context).canvasColor),
            //       //     splashColor:
            //       //         Theme.of(context).canvasColor.withOpacity(.4),
            //       //     onPressed: //open snackbar Get.snackbar('title', 'message');
            //       //         () {},
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 55,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                    ),
                  ),
                  LocooCircularIconButton(
                    iconData: FlutterRemix.pencil_line,
                    fillColor: Theme.of(context).primaryColor,
                    iconColor: Colors.white,
                    radius: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28),

            TextFormField(
              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Vorname',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 10),

            TextFormField(
              // controller: controller.emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nachname',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
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
                      'Zeiger nur den ersten Buchstaben deines Nachnahmen an',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6)),
                    ),
                  ),

                  //tranform  scale 0.8 cupertuon swtich
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: Theme.of(context).primaryColor,
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // NextElevatedButton(
            //   rtl: true,
            //   onPressed: //controller.addPost() and go to
            //       () {
            //     controller.goToPage(1);
            //     FocusScope.of(context).unfocus();
            //     // Get.to(PublishedNewPostView());
            //   },
            //   controller: controller,
            //   icon: Icons.chevron_left_outlined,
            //   label: 'Weiter',
            // ),
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
