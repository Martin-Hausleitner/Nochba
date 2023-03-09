import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/pages/private_profile/views/settings/manage_account_view.dart';

class ManageAccountController extends GetxController {
  final _authService = Get.find<AuthService>();

  Future onDeleteAccountTap(BuildContext context) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialogDeleteAccount(
        onDelete: () async {
          await _authService.deleteAccountAndUserData();
          await _authService.signOut();
        },
      ),
    );
    if (result != null && result == true) {
      Get.back();
      Get.back();
    }
  }

  Stream<String?> getEmail() {
    return Stream.value(_authService.getEmailOfCurrentUser());
  }

  TextEditingController emailTextController = TextEditingController();

  TextEditingController getEmailTextController(String email) {
    emailTextController.text = email;
    return emailTextController;
  }

  final emailKey = GlobalKey<FormState>();

  String? validateEmail(String? email) {
    return email != null && email.trim().isEmpty
        ? 'Geben Sie bitte eine Email ein'
        : email != null && !email.isEmail
            ? 'Geben Sie bitte eine gültige Email ein'
            : null;
  }

  Future<void> updateEmailOfCurrentUser() async {
    if (!emailKey.currentState!.validate()) {
      return;
    }

    try {
      return await _authService
          .updateEmailOfCurrentUser(emailTextController.text);
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        Get.snackbar(
            'Ungültige Email', 'Bitte geben Sie eine gültige Email an');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
            'Email vergeben', 'Die angegebene Email ist schon vergeben');
      } else if (e.code == 'requires-recent-login') {
        Get.snackbar('Nicht eingeloggt', 'Sie sind nicht angemeldet');
      } else {
        Get.snackbar('Error', '$e');
      }
    }
  }

  TextEditingController firstPasswordTextController = TextEditingController();
  TextEditingController secondPasswordTextController = TextEditingController();

  final passwordKey = GlobalKey<FormState>();

  String? validatePassword(String? password) {
    return password != null && password.trim().isEmpty
        ? 'Geben Sie bitte ein Password ein'
        : password != null && password.trim().length < 6
            ? 'Das Password muss länger als 6 Zeichen sein'
            : null;
  }

  Future<void> updatePasswordOfCurrentUser() async {
    if (!passwordKey.currentState!.validate()) {
      return;
    }
    if (firstPasswordTextController.text.trim() !=
        secondPasswordTextController.text.trim()) {
      Get.snackbar(
          'Ungleiche Passwörter', 'Die Passwörter müssen die gleichen sein');
    }

    try {
      return await _authService
          .updatePasswordOfCurrentUser(firstPasswordTextController.text.trim());
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Schwaches Passwort',
            'Dass Passwort muss länger als 6 Zeichen lang sein');
      } else if (e.code == 'requires-recent-login') {
        Get.snackbar('Nicht eingeloggt', 'Sie sind nicht angemeldet');
      } else {
        Get.snackbar('Error', '$e');
      }
    }
  }

  final _userPrivateInfoSettingsRepository =
      Get.find<UserPrivateInfoSettingsRepository>();

  Stream<bool?> getPermReqBeforeChatOfCurrentUser() {
    try {
      return _userPrivateInfoSettingsRepository
          .getPermReqBeforeChatOfCurrentUser();
    } catch (e) {
      return Stream.error(Error);
    }
  }

  Future<void> updatePermReqBeforeChatOfCurrentUser(bool value) async {
    try {
      return await _userPrivateInfoSettingsRepository
          .updatePermReqBeforeChatOfCurrentUser(value);
    } catch (e) {
      Get.snackbar(
          'Fehlgeschlagen', 'Das Umschalten ist leider fehlgeschlagen');
    }
  }

  @override
  void dispose() {
    emailTextController.dispose();
    firstPasswordTextController.dispose();
    secondPasswordTextController.dispose();
    super.dispose();
  }
}
