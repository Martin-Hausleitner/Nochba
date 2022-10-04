import 'package:flutter/material.dart';
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
    return AppBarBigView(
      showBackButton: false,
      title: 'Herzlich Wilkommen',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        LocooTextButton(
          label: 'Anmelden',
          onPressed: () async => {await Get.to(() => const LoginPage())},
          icon: Icons.login,
        ),
        const SizedBox(height: 5),
        LocooTextButton(
            label: 'Registrieren',
            onPressed: () async => {await Get.to(() => const NewSignUpPage())},
            icon: Icons.account_box_sharp),
        const SizedBox(height: 5),
        LocooTextButton(
          label: 'Erstelle einen Demo Account',
          onPressed: () async => controller.createDemoAccount(),
          icon: Icons.accessibility,
        ),
      ],
    );
  }
}
