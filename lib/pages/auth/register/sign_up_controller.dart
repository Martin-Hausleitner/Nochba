import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/ImageFile.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final ImageFile _imageFile = ImageFile();
  Uint8List? get image => _imageFile.file;

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

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select a profile picture'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Pick an image'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.camera);
                },
              ),
              if (!_imageFile.isClear())
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Delete the image'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await deleteImage();
                  },
                )
            ],
          );
        });
  }

  pickImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource);

    if (file != null) {
      _imageFile.name = file.name;
      _imageFile.file = await file.readAsBytes();

      update();
    }
  }

  deleteImage() {
    _imageFile.clear();
    update();
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
    _imageFile.clear();
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
          lastNameController.text.trim(),
          _imageFile,
          showLastName);
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
    _imageFile.clear();
    firstNameController.clear();
    lastNameController.clear();
    Get.back();
  }
}
