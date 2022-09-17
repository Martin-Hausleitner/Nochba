import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';

import 'register/sign_up_page.dart';

class SignUpPage extends GetView<AuthController> {
  final VoidCallback onClicked;
  const SignUpPage({Key? key, required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: controller.formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const FlutterLogo(size: 120),
                    const SizedBox(height: 20),
                    const Text('Welcome back\nto the neighbourhood',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 40),
                    TextFormField(
                        controller: controller.emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) => email != null &&
                                false /*!EmailValidator.validate(email)*/
                            ? 'Enter a valid email'
                            : null),
                    const SizedBox(height: 4),
                    LocooTextField(
                        label: 'First Nam',
                        controller: controller.passwordController,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 2
                            ? 'Enter min. 2 characters'
                            : null),
                    const SizedBox(height: 4),
                    TextFormField(
                        controller: controller.lastNameController,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 2
                            ? 'Enter min. 2 characters'
                            : null),
                    const SizedBox(height: 4),
                    /*TextFormField(
                controller: controller.birthdayController,
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Birthday'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => 
                  value != null && DateTime.tryParse(value.trim()) == null
                  ? 'Enter a valid date'
                  : null
              ),*/

                    const SizedBox(height: 4),
                    TextFormField(
                        controller: controller.passwordController,
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter min. 6 characters'
                            : null),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 32),
                      label:
                          const Text('Sign Up', style: TextStyle(fontSize: 24)),
                      onPressed: controller.signUp,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          text: 'Already have an account? ',
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = onClicked,
                                text: 'Log In',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ))
                          ]),
                    ),
                    //button which opens SignUpPage

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 32),
                      label: const Text('New Sign Up',
                          style: TextStyle(fontSize: 24)),
                      onPressed: //open NewSignUpPage widget
                          () => Get.to(NewSignUpPage()),
                    ),
                  ]))),
    );
  }
}
