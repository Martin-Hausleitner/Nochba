import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';

class LoginController extends GetxController {
  final authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    try {
      await authService.signIn(
          emailController.text.trim(), passwordController.text.trim());
      getBack();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        Get.snackbar(
            'Ungültige Email', 'Bitte geben Sie eine gültige Email an');
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
            'Falsches Passwort', 'Bitte geben Sie das richtige Passwort ein');
      } else if (e.code == 'user-not-found') {
        Get.snackbar('Nicht vorhanden', 'Der Account ist nicht vorhanden');
      } else if (e.code == 'user-disabled') {
        Get.snackbar(
            'Zugang verweigert', 'Dem Account wurde der Zugang verweigert');
      } else {
        Get.snackbar('Error', '$e');
      }
    }
  }

  void getBack() {
    emailController.clear();
    passwordController.clear();
    Get.back();
  }
}
