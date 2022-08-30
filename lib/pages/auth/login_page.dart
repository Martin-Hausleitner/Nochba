import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';

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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 60),
            const SizedBox(height: 20),
            const Text('Locoo Beta',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 40),
            TextField(
                controller: controller.emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 4),
            TextField(
              controller: controller.passwordController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text('Sign In', style: TextStyle(fontSize: 24)),
              onPressed: controller.signIn,
            ),
            /*GestureDetector(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20
                ),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ForgotPasswordPage()
              )),
            ),*/
            RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  text: 'No Account? ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = onClicked,
                        text: 'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                        ))
                  ]),
            ),
            const SizedBox(height: 24),
            LocooTextButton(
                text: 'Create a demo account',
                onPressed: () async => controller.createDemoAccount(),
                icon: Icons.account_box)
          ])),
    );
  }
}
