import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final Rx<bool> _showLastName = true.obs;
  bool get showLastName => _showLastName.value;

  final pageController = PageController(initialPage: 0);
  final currentPage = 0.obs;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  String? validateEmail(String? email) {
    return email != null && email.trim().isEmpty
        ? 'Geben Sie bitte eine Email ein'
        : email != null && !email.isEmail
            ? 'Geben Sie bitte eine gültige Email ein'
            : null;
  }

  String? validatePassword(String? password) {
    return password != null && password.trim().isEmpty
        ? 'Geben Sie bitte ein Password ein'
        : password != null && password.trim().length < 6
            ? 'Das Password muss länger als 6 Zeichen sein'
            : null;
  }

  String? validateFirstName(String? firstName) {
    return firstName != null && firstName.trim().isEmpty
        ? 'Geben Sie bitte einen Vornamen ein'
        : firstName != null && firstName.trim().length < 2
            ? 'Der Vorname muss länger als 2 Zeichen sein'
            : null;
  }

  String? validateLastName(String? lastName) {
    return lastName != null && lastName.trim().isEmpty
        ? 'Geben Sie bitte einen Nachnamen ein'
        : lastName != null && lastName.trim().length < 2
            ? 'Der Nachname muss länger als 2 Zeichen sein'
            : null;
  }

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
      if (!formKey1.currentState!.validate()) {
        return;
      }
    } else if (pageController.page == 1) {
      if (!formKey2.currentState!.validate()) {
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
      getBack();
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

  void getBack() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    Get.back();
  }
}
