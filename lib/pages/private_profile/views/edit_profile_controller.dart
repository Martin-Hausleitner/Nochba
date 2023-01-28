import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/UserPrivateInfoSettings.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';
import 'package:nochba/views/new_post/tag_dialog.dart';
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

  DateRangePickerController birthdayDateController = DateRangePickerController();
  DateRangePickerController getBirthdayDateController(Timestamp? birthday) {
    birthdayDateController.selectedDate = birthday?.toDate();
    return birthdayDateController;
  }

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
  final userPrivateInfoNameRepository =
      Get.find<UserPrivateInfoNameRepository>();
  final userPrivateInfoSettingsRepository =
      Get.find<UserPrivateInfoSettingsRepository>();

  final ImageFile _imageFile = ImageFile();
  Uint8List? get image => _imageFile.file;

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
                  await updateProfilePicture();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.camera);
                  await updateProfilePicture();
                },
              ),
              if (!_imageFile.isClear())
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Delete the image'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await deleteImage();
                    await updateProfilePicture();
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

  Future updateProfilePicture() async {
    final storageService = Get.find<StorageService>();

    final imageUrl = !_imageFile.isClear()
        ? await storageService.uploadProfileImageToStorage(_imageFile.file!)
        : '';

    userRepository.updateProfilePictureOfCurrentUser(imageUrl);
  }

  Stream<UserPrivateInfoName?> getCurrentUserName() {
    try {
      return userPrivateInfoNameRepository.getCurrentUserAsStream();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Stream<bool?> getCurrentUserSettingForLastName() {
    try {
      return userPrivateInfoSettingsRepository
          .getLastNameInitialOnlyOfCurrentUser();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Stream<User?> getCurrentUser() {
    try {
      return userRepository.getCurrentUserAsStream();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Stream<UserPublicInfo?> getPublicInfoOfCurrentUser() {
    try {
      return userPublicInfoRepository.getPublicInfoOfCurrentUserAsStream();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<void> updateNameOfCurrentUser() async {
    try {
      await userPrivateInfoNameRepository.updateNameOfCurrentUser(
          firstNameTextController.text.trim(),
          lastNameTextController.text.trim());
      //firstNameTextController.clear();
      //lastNameTextController.clear();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> updateSettingForLastNameOfCurrentUser(bool value) async {
    try {
      await userPrivateInfoSettingsRepository
          .updateLastNameInitialOnlyOfCurrentUser(value);
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

  Future<void> updateBirthdayOfCurrentUser(value) async {
    try {
      //await userPublicInfoRepository.updateBirthdayOfCurrentUser(value);
    } on Exception {
      return Future.error(Error);
    }
  }


  
  final RxList<String> _tags = <String>[].obs;

  List<String> get tags => _tags;

  addTag(String tag) {
    _tags.add(tag);
  }

  addTags(List<String> tags) {
    _tags.addAll(tags);
  }

  removeTag(String tag) {
    _tags.remove(tag);
  }



  void showTagDialog(BuildContext context) async {
    final String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TagDialog();
      },
    );

    addTag(result);
  }
}
