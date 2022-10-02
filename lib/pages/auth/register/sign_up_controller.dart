import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/auth/AuthService.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final Rx<bool> _showLastName = true.obs;
  bool get showLastName => _showLastName.value;

  final pageController = PageController(initialPage: 0);
  final currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page!.round();
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }

  void nextPage() {
    if (pageController.page == 0) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Falsche Angabe',
            'Bitte geben Sie eine gültige Email und ein gültiges Passwort ein');
        return;
      }
      if (!GetUtils.isEmail(emailController.text.trim())) {
        Get.snackbar(
            'Ungültige Email', 'Bitte geben Sie eine gültige Email an');
        return;
      }
      if (passwordController.text.trim().length < 6) {
        Get.snackbar('Schwaches Passwort',
            'Dass Passwort muss länger als 6 Zeichen lang sein');
        return;
      }
    } else if (pageController.page == 1) {
      if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
        Get.snackbar('Falsche Angabe',
            'Bitte geben Sie einen gültigen Vor- und Nachnamen ein');
        return;
      }
    }

    pageController.nextPage(
        duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  void setShowLastName(bool show) {
    _showLastName.value = show;
  }

  final authService = Get.find<AuthService>();

  Future signUp() async {
    try {
      await authService.signUp(
          emailController.text.trim(),
          passwordController.text.trim(),
          firstNameController.text.trim(),
          lastNameController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        Get.snackbar(
            'Ungültige Email', 'Bitte geben Sie eine gültige Email an');
        goToPage(0);
      } else if (e.code == 'weak-password') {
        Get.snackbar('Schwaches Passwort',
            'Dass Passwort muss länger als 6 Zeichen lang sein');
        goToPage(0);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
            'Vergebene Email', 'Die angegebene Email ist schon vergeben');
        goToPage(0);
      } else {
        Get.snackbar('Error', '$e');
      }
    }
  }
}
