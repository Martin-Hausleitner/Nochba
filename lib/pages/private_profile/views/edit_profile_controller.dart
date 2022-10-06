import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditProfileController extends GetxController {
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController getFirstNameTextController(String? firstName) {
    firstNameTextController.text = firstName ?? '';
    return firstNameTextController;
  }

  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController getLastNameTextController(String? lastName) {
    lastNameTextController.text = lastName ?? '';
    return lastNameTextController;
  }

  DateRangePickerController birthdayDateController =
      DateRangePickerController();

  TextEditingController professionTextController = TextEditingController();
  TextEditingController getProfessionTextController(String? profession) {
    professionTextController.text = profession ?? '';
    return professionTextController;
  }

  TextEditingController bioTextController = TextEditingController();
  TextEditingController getBioTextController(String? bio) {
    bioTextController.text = bio ?? '';
    return bioTextController;
  }

  // More about the user
  TextEditingController interestsTextController = TextEditingController();
  TextEditingController offeringsTextController = TextEditingController();
  // Family details
  TextEditingController familyStatusTextController = TextEditingController();
  TextEditingController numOfKidsTextController = TextEditingController();
  TextEditingController petsTextController = TextEditingController();

  final userRepository = Get.find<UserRepository>();
  final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();

  Stream<User?> getCurrentUserAsStream() {
    try {
      return userRepository.getCurrentUserAsStream();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<User?> getCurrentUser() {
    try {
      return userRepository.getCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }

  Stream<UserPublicInfo?> getPublicInfoOfCurrentUser() {
    try {
      return userPublicInfoRepository.getPublicInfoOfCurrentUser();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<void> updateNameOfCurrentUser() async {
    try {
      await userRepository.updateNameOfCurrentUser(
          firstNameTextController.text.trim(),
          lastNameTextController.text.trim());
      //firstNameTextController.clear();
      //lastNameTextController.clear();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> updateProfessionOfCurrentUser() async {
    try {
      await userPublicInfoRepository
          .updateProfessionOfCurrentUser(professionTextController.text.trim());
      //professionTextController.clear();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> updateBioOfCurrentUser() async {
    try {
      await userPublicInfoRepository
          .updateBioOfCurrentUser(bioTextController.text.trim());
      //bioTextController.clear();
    } on Exception {
      return Future.error(Error);
    }
  }
}
