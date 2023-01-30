import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/pages/auth/register/views/sign_up_step_4_view.dart';
import 'package:nochba/pages/auth/register/widgets/invite_code_input.dart'
    as ici;

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final streetController = TextEditingController();
  final streetNumberController = TextEditingController();

  final cityController = TextEditingController();
  final zipController = TextEditingController();

  final ImageFile _imageFile = ImageFile();
  Uint8List? get image => _imageFile.file;

  final Rx<bool> _showLastName = true.obs;
  bool get showLastName => _showLastName.value;

  SingingCharacter? verificationOption;

  final pageController = PageController(initialPage: 0);
  final currentPage = 0.obs;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

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

  String? validateAddress(String? address) {
    return address != null && address.trim().isEmpty
        ? 'Füllen Sie bitte das Feld aus'
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

  void setShowLastName(bool show) {
    _showLastName.value = show;
  }

  void setVerificationOption(SingingCharacter? sc) {
    verificationOption = sc;
  }

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page!.round();
    });
  }

  @override
  void onClose() async {
    await clearAllFields();
    super.onClose();
  }

  Future nextPage({BuildContext? context}) async {
    try {
      if (pageController.page == 0) {
        if (!formKey1.currentState!.validate()) {
          return;
        }

        await signUpWithEmail();
      } else if (pageController.page == 1) {
        if (!formKey2.currentState!.validate()) {
          return;
        }

        await createUser();
      } else if (pageController.page == 2) {
        if (!formKey3.currentState!.validate()) {
          return;
        }

        await addUserAddress();
      } else if (pageController.page == 3) {
        if (verificationOption == null) {
          return;
        }

        if (verificationOption == SingingCharacter.location) {
          await authService.addUserCoordinates();
        } else if (verificationOption == SingingCharacter.qrcode &&
            context != null) {
          final result = await inviteCodeInput(context);
          Get.snackbar('Result', result.toString());
        } else {
          return;
        }
      }

      await pageController.nextPage(
          duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
    } catch (e) {}
  }

  Future previousPage() async {
    if (pageController.page == 1) {
      emailController.clear();
      passwordController.clear();
      await deleteAccount();
    } else if (pageController.page == 2) {
      _imageFile.clear();
      setShowLastName(true);
      firstNameController.clear();
      lastNameController.clear();

      await deleteUser();
    } else if (pageController.page == 3) {
      streetController.clear();
      streetNumberController.clear();
      cityController.clear();
      zipController.clear();

      await authService.deleteUserAddress();
    }

    pageController.previousPage(
      duration: const Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  final authService = Get.find<AuthService>();

  Future signUpWithEmail() async {
    try {
      final result = await authService.signUpWithEmail(
          emailController.text.trim(), passwordController.text.trim());

      if (!result) {
        Get.snackbar('Fehler aufgetreten',
            'Bitte überprüfen Sie Ihre Eingabefelder noch einmal');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        Get.snackbar(
            'Ungültige Email', 'Bitte geben Sie eine gültige Email an');
      } else if (e.code == 'weak-password') {
        Get.snackbar('Schwaches Passwort',
            'Dass Passwort muss länger als 6 Zeichen lang sein');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
            'Email vergeben', 'Die angegebene Email ist schon vergeben');
      } else {
        Get.snackbar('Error', '$e');
      }
      rethrow;
    }
  }

  Future deleteAccount() async {
    try {
      final result = await authService.deleteAccount();

      if (!result) {
        Get.snackbar('Fehler aufgetreten',
            'Es ist ein Fehler beim zurückgehen aufgetreten');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Get.snackbar('Nicht angemeldet', 'Sie sind nicht angemeldet');
      } else {
        Get.snackbar('Error', '$e');
      }
      rethrow;
    }
  }

  Future createUser() async {
    try {
      final result = await authService.createUser(
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          _imageFile,
          showLastName);

      if (!result) {
        Get.snackbar('Fehler aufgetreten',
            'Bitte überprüfen Sie Ihre Eingabefelder noch einmal');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', '$e');
      Get.snackbar(
          'Achtung', 'Ein Fehler bei der Registrierung ist aufgetreten');
      rethrow;
    }
  }

  Future deleteUser() async {
    try {
      final result = await authService.deleteUserData();

      if (!result) {
        Get.snackbar('Fehler aufgetreten',
            'Es ist ein Fehler beim zurückgehen aufgetreten');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', '$e');
      Get.snackbar(
          'Achtung', 'Ein Fehler bei der Registrierung ist aufgetreten');
      rethrow;
    }
  }

  Future addUserAddress() async {
    try {
      final result = await authService.addUserAddress(
        streetController.text.trim(),
        streetNumberController.text.trim(),
        cityController.text.trim(),
        zipController.text.trim(),
      );

      if (!result) {
        Get.snackbar('Fehler aufgetreten',
            'Bitte überprüfen Sie Ihre Eingabefelder noch einmal');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', '$e');
      Get.snackbar(
          'Achtung', 'Ein Fehler bei der Registrierung ist aufgetreten');
      rethrow;
    }
  }

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

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  Future getBack() async {
    emailController.clear();
    passwordController.clear();
    _imageFile.clear();
    firstNameController.clear();
    lastNameController.clear();

    Get.back();
  }

  Future finishRegistration() async {
    await clearAllFields();
    Get.back();
  }

  Future quitRegistration() async {
    await authService.deleteAccountAndUserData();
    await clearAllFields();
    Get.back();
  }

  Future clearAllFields() async {
    emailController.clear();
    passwordController.clear();
    _imageFile.clear();
    setShowLastName(true);
    firstNameController.clear();
    lastNameController.clear();
    streetController.clear();
    streetNumberController.clear();
    cityController.clear();
    zipController.clear();
  }

  Future inviteCodeInput(BuildContext context) {
    return //show bottom sheet
        showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(
            children: [
              ici.QRcodeScanner(),

              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8),
                      BlendMode.srcOut), // This one will create the magic
                  child: Stack(
                    // fit: StackFit.expand,
                    children: [
                      Container(
                        height: 4000,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            backgroundBlendMode: BlendMode
                                .dstOut), // This one will handle background + difference out
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            //red border only in the cornders
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ici.CloseButton(),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Text(
                    'Scanne deinen QR Einladecode',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              //possiton on the bottom of the sheet a locoo button which opens a textfield
              ici.EnterCodeManualButton(
                checkQRCode: (qrCode) =>
                    authService.checkVerificationCode(qrCode),
              ),
            ],
          ),
        );
      },
    );
  }
}
