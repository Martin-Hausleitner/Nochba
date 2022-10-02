import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/models/user.dart';
import 'package:locoo/logic/repositories/UserRepository.dart';

class EditProfileController extends GetxController {

  TextEditingController firstNameTextController = new TextEditingController();
  TextEditingController lastNameTextController = new TextEditingController();


  final userRepository = Get.find<UserRepository>();

  Stream<User?> getCurrentUser() {
    try {
      return userRepository.getCurrentUserAsStream();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<void> updateNameOfCurrentUser() async {
    try {
      await userRepository.updateNameOfCurrentUser(
        firstNameTextController.text.trim(), 
        lastNameTextController.text.trim()
        );
    } on Exception {
      return Future.error(Error);
    }
  }
}
