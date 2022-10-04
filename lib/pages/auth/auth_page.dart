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
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1607554076394-31ddab697f7c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80'),
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
                      child: Text(
                        'Willkommen in\ndeiner Nachbarschaft',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                              letterSpacing: -0.4,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
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
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        LocooTextButton(
                          label: 'Anmelden',
                          icon: Icons.login,
                          onPressed: () async =>
                              {await Get.to(() => const LoginPage())},
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        LocooTextButton(
                          label: 'Regestrieren',
                          icon: Icons.login,
                          onPressed: () async =>
                              {await Get.to(() => const NewSignUpPage())},
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
