import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nochba/logic/auth/AuthService.dart';

class LoginController extends GetxController {
  final authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Überprüfen, ob der Benutzer mit dieser E-Mail-Adresse bereits registriert ist
      final email = googleUser.email;
      final isRegistered = await authService.isUserRegistered(email);
      if (!isRegistered) {
        // Wenn der Benutzer nicht registriert ist, anzeigen einer Snackbar
        Get.snackbar('Nicht registriert',
            'Es gibt kein Konto mit der eingegebenen E-Mail-Adresse');
        return;
      }

      // Anmeldung über Firebase-Auth mithilfe von Credential von Google-Auth
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.back();
    } catch (error) {
      print('Google Sign In Error: $error');
    }
  }

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
