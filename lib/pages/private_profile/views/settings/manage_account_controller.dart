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

  Future<String?> getEmailOfCurrentUser() {
    return Future.value(_authService.getEmailOfCurrentUser());
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

  Future<bool> updateEmailOfCurrentUser() async {
    if (!emailKey.currentState!.validate()) {
      return false;
    }

    try {
      await _authService.updateEmailOfCurrentUser(emailTextController.text);

      final newEmail = await getEmailOfCurrentUser();
      emailTextController.text = newEmail ?? '';
    } on FirebaseException catch (e) {
      String errorText = '';
      if (e.code == 'invalid-email') {
        errorText = 'Bitte geben Sie eine gültige Email an';
      } else if (e.code == 'email-already-in-use') {
        errorText = 'Die angegebene Email ist schon vergeben';
      } else if (e.code == 'requires-recent-login') {
        errorText = 'Sie benötigen eine kürzliche Anmeldung';
      } else {
        errorText = e.toString();
      }
      return Future.error(errorText);
    }

    return true;
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

  Future<bool> updatePasswordOfCurrentUser() async {
    if (!passwordKey.currentState!.validate()) {
      return false;
    }
    if (firstPasswordTextController.text.trim() !=
        secondPasswordTextController.text.trim()) {
      return Future.error('Die Passwörter müssen gleich sein');
    }

    try {
      await _authService
          .updatePasswordOfCurrentUser(firstPasswordTextController.text.trim());

      firstPasswordTextController.clear();
      secondPasswordTextController.clear();
    } on FirebaseException catch (e) {
      String errorText = '';
      if (e.code == 'weak-password') {
        errorText = 'Dass Passwort muss länger als 6 Zeichen lang sein';
      } else if (e.code == 'requires-recent-login') {
        errorText = 'Sie benötigen eine kürzliche Anmeldung';
      } else {
        errorText = e.toString();
      }
      return Future.error(errorText);
    }

    return true;
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
