import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/edit_avatar.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpStep2View extends StatelessWidget {
  const SignUpStep2View({super.key, required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
        tailingIcon: Icons.close_rounded,
        title: 'Registrieren',
        onPressed: () async => await controller.quitRegistration(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleStep(3, '1', () {}),
                  const ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(1, '2', () {}),
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
                'Gebe deinen Namen und ein Profilbild ein',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
              //tile small Schritt 1 von 3
              const SizedBox(height: 2),
              Text(
                'Schritt 2 von 4',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // fontSize: 18,
                    // fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                    ),
              ),
              const SizedBox(height: 25),
              GetBuilder<SignUpController>(
                builder: (c) => EditAvatar(
                  image: controller.image,
                  onTap: controller.selectImage,
                ),
              ),
              // Center(
              //   child: Stack(
              //     alignment: Alignment.bottomRight,
              //     children: [
              //       CircleAvatar(
              //         backgroundColor: Colors.black26,
              //         radius: 55,
              //         backgroundImage: NetworkImage(
              //           "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
              //         ),
              //       ),
              //       LocooCircularIconButton(
              //         iconData: FlutterRemix.pencil_line,
              //         fillColor: Theme.of(context).primaryColor,
              //         iconColor: Colors.white,
              //         radius: 32,
              //         onPressed: () => Navigator.pop(context),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 28),

              Form(
                  key: controller.formKey2,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      LocooTextField(
                        label: 'Vorname',
                        controller: controller.firstNameController,
                        validator: controller.validateFirstName,
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      LocooTextField(
                        label: 'Nachname',
                        controller: controller.lastNameController,
                        validator: controller.validateLastName,
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  )),
              Padding(
                padding: // right left 5
                    const EdgeInsets.only(
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
                        child: Obx(
                          () => CupertinoSwitch(
                            activeColor: Theme.of(context).primaryColor,
                            value: controller.showLastName,
                            onChanged: controller.setShowLastName,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),

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
        ]);
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
