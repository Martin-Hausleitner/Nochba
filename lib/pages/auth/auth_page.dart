import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/login_page.dart';
import 'package:locoo/pages/auth/signUp_page.dart';
import 'package:locoo/pages/auth/auth_controller.dart';

import 'register/sign_up_page.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Obx(
      () => controller.isLogin
          ? LoginPage(onClicked: controller.toggle)
          //: SignUpPage(onClicked: controller.toggle),
          : const NewSignUpPage(),
    );
  }
}
