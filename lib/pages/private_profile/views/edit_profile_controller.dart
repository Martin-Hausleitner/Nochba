import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class EditProfileController extends GetxController {
  TextEditingController firstNameTextController = new TextEditingController();
  TextEditingController lastNameTextController = new TextEditingController();
  TextEditingController jobTitleTextController = new TextEditingController();
  TextEditingController bioTextController = new TextEditingController();
  // More about the user
  TextEditingController interestsTextController = new TextEditingController();
  TextEditingController offeringsTextController = new TextEditingController();
  // Family details
  TextEditingController familyStatusTextController = new TextEditingController();
  TextEditingController numOfKidsTextController = new TextEditingController();
  TextEditingController petsTextController = new TextEditingController();

// reference to userProfileInfo collection in firestore
  final CollectionReference userProfileInfo =
      FirebaseFirestore.instance.collection('userProfileInfo');


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
          lastNameTextController.text.trim());
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> updateJobTitleOfCurrentUser() async {
    String userId = userRepository.resourceContext.uid;
    try {
      await userProfileInfo.doc(userId).set({
        'jobTitle': jobTitleTextController.text.trim(),
      });
    } on Exception {
      return Future.error(Error);
    }
  }




  
}
