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
  TextEditingController lastNameTextController = TextEditingController();
  DateRangePickerController birthdayDateController =
      DateRangePickerController();
  TextEditingController jobTitleTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();
  // More about the user
  TextEditingController interestsTextController = TextEditingController();
  TextEditingController offeringsTextController = TextEditingController();
  // Family details
  TextEditingController familyStatusTextController =
      new TextEditingController();
  TextEditingController numOfKidsTextController = new TextEditingController();
  TextEditingController petsTextController = new TextEditingController();

  final userRepository = Get.find<UserRepository>();
  final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();

  Stream<User?> getCurrentUser() {
    try {
      return userRepository.getCurrentUserAsStream();
    } on Exception {
      return Stream.error(Error);
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
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> updateJobTitleOfCurrentUser() async {
    try {
      /*await userProfileInfo.doc(userId).set({
        'jobTitle': jobTitleTextController.text.trim(),
      });*/
    } on Exception {
      return Future.error(Error);
    }
  }
}
