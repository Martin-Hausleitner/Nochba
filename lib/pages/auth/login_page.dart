import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';

class LoginPage extends GetView<AuthController> {
  final VoidCallback onClicked;
  const LoginPage({Key? key, required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (kIsWeb)
              Column(
                //align center
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const Text(
                    'Locoo Beta',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),

                  // add a body smaall text 'Die Beta ist noch in Entwicklung also sehr absolut nicht geeignet für die Produktion'
                  Text(
                    'Die Beta Version für die Webversion ist noch sehr unstable also treten viele Bugs auf',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 24),
                  LocooTextButton(
                    text: 'Erstelle einen Demo Account',
                    onPressed: () async => controller.createDemoAccount(),
                    icon: Icons.login,
                  ),
                ],
              ),

            // if (kIsWeb) show a button to open the web version
            if (!kIsWeb)
              Column(
                children: [
                  const SizedBox(height: 40),
                  LocooTextField(
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    label: 'Email',
                  ),
                  const SizedBox(height: 4),
                  LocooTextField(
                    label: 'Password',
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  LocooTextButton(
                    text: 'Erstelle einen Demo Account',
                    onPressed: controller.signIn,
                    icon: Icons.login,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.lock_open, size: 32),
                    label:
                        const Text('Sign In', style: TextStyle(fontSize: 24)),
                    onPressed: controller.signIn,
                  ),
                  //       GestureDetector(
                  //   child: Text(
                  //     'Forgot Password?',
                  //     style: TextStyle(
                  //       decoration: TextDecoration.underline,
                  //       color: Theme.of(context).colorScheme.secondary,
                  //       fontSize: 20
                  //     ),
                  //   ),
                  //   // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //   //   builder: (context) => ForgotPasswordPage()
                  //   // )),
                  // ),
                  RichText(
                    text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        text: 'No Account? ',
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = onClicked,
                              text: 'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.secondary,
                              ))
                        ]),
                  ),
                  LocooTextButton(
                    text: 'Erstelle einen Demo Account',
                    onPressed: () async => controller.createDemoAccount(),
                    icon: Icons.login,
                  ),
                ],
              ),

            // if (!Platform.isAndroid)
          ],
        ),
      ),
    );
  }
}
