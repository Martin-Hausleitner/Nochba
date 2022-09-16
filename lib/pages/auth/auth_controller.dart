import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/auth_access.dart';

class AuthController extends GetxController {
  Rx<bool> _isLogin = true.obs;

  bool get isLogin => _isLogin.value;

  final authAccess = Get.find<AuthAccess>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthdayController = TextEditingController();

  void toggle() => _isLogin.value = !_isLogin.value;
  
  Future signIn() async {
    authAccess.signIn(emailController.text.trim(), passwordController.text.trim());
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    authAccess.signUp(
      emailController.text.trim(), 
      passwordController.text.trim(), 
      firstNameController.text.trim(), 
      lastNameController.text.trim()
    );
  }

  Future createDemoAccount() async {
    final faker = Faker();
    final firstName = faker.person.firstName();
    final lastName = faker.person.lastName();
    final email =
        '${firstName.toLowerCase()}.${lastName.toLowerCase()}@${faker.internet.domainName()}';
    const password = '123456';

    await authAccess.signUp(
      email, 
      password, 
      firstName, 
      lastName
    );

    /*emailController.text = email;
    passwordController.text = password;*/
  }

  @override void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    birthdayController.dispose();
    super.dispose();
  }
}