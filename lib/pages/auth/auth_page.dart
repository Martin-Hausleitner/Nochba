import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/auth/login_page.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import 'register/sign_up_page.dart';

/*class AuthPage2 extends GetView<AuthController> {
  const AuthPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Obx(
      () => controller.isLogin
          ? LoginPage(onClicked: controller.toggle)
          //: SignUpPage(onClicked: controller.toggle),
          : NewSignUpPage(
              onClicked: controller.toggle,
            ),
    );
  }
}*/

class AuthPage extends GetView<AuthController> {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/auth_page_background.jpg'), // <-- BACKGROUND IMAGE
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //a white icon button align left

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () async =>
                                controller.createDemoAccount(),
                            icon: Icon(
                              FlutterRemix.user_add_line,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: //top 20 left 12
                          const EdgeInsets.only(top: 70, left: 12, right: 12),
                      child: Column(
                        //align start
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Willkommen in',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  letterSpacing: -0.4,
                                  color: Colors.white,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                'deiner ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30,
                                      letterSpacing: -0.4,
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                'Nochba',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 30,
                                      letterSpacing: -0.4,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              Text(
                                'schaft',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                      letterSpacing: -0.4,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  // height: 140,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // LocooTextButton(
                        //   label: 'Anmelden',
                        //   icon: Icons.login,
                        //   onPressed: () async =>
                        //       {await Get.to(() => const LoginPage())},
                        // ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60),
                            primary: Theme.of(context).colorScheme.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // splashFactory: InkRipple.splashFactory,
                            // enableFeedback: true,
                          ),
                          child: Text(
                            'Anmelden',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -0.07,
                                ),
                          ),
                          // onPressed: () async =>
                          //     {await Get.to(() => const LoginPage())},
                          onPressed: () async => {
                            await Get.to(
                              () => const LoginPage(),
                              transition: Transition.rightToLeft,
                            )
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: () async => {
                            await Get.to(
                              () => const NewSignUpPage(),
                              transition: Transition.leftToRight,
                              // gestureWidth: 100,
                            )
                          },
                          child: Text(
                            'Regestrieren',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.onPrimary,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
