import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';
import 'package:nochba/views/new_post/tag_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
  DateRangePickerController getBirthdayDateController(DateTime? birthday) {
    birthdayDateController.selectedDate = birthday;
    return birthdayDateController;
  }

  DateRangePickerController neighbourhoodMemberSinceController =
      DateRangePickerController();
  DateRangePickerController getNeighbourhoodMemberSinceDateController(
      DateTime? neighbourhoodMemberSince) {
    neighbourhoodMemberSinceController.selectedDate = neighbourhoodMemberSince;
    return neighbourhoodMemberSinceController;
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

  selectImage(BuildContext context, bool userHasProfilePicture) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Select an image"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.gallery);
                  await updateProfilePicture();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.camera);
                  await updateProfilePicture();
                },
              ),
              if (!_imageFile.isClear() || userHasProfilePicture)
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Delete the image"),
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

  Future<bool> updateNameOfCurrentUser() async {
    try {
      await userPrivateInfoNameRepository.updateNameOfCurrentUser(
          firstNameTextController.text.trim(),
          lastNameTextController.text.trim());
      //firstNameTextController.clear();
      //lastNameTextController.clear();
    } on Exception {
      return Future.error(
          'The name could not be updated. Please try again later.');
    }

    return true;
  }

  Future<void> updateSettingForLastNameOfCurrentUser(bool value) async {
    try {
      await userPrivateInfoSettingsRepository
          .updateLastNameInitialOnlyOfCurrentUser(value);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<bool> updateProfessionOfCurrentUser() async {
    try {
      await userPublicInfoRepository
          .updateProfessionOfCurrentUser(professionTextController.text.trim());
      //professionTextController.clear();
    } on Exception {
      return Future.error(
          'The profession could not be updated. Please try again later.');
    }

    return true;
  }

  Future<bool> updateBioOfCurrentUser() async {
    try {
      await userPublicInfoRepository
          .updateBioOfCurrentUser(bioTextController.text.trim());
    } on Exception {
      return Future.error(
          'The bio could not be updated. Please try again later.');
    }

    return true;
  }

  Future<bool> updateBirthDayOfCurrentUser() async {
    try {
      await userPublicInfoRepository
          .updateBirthDayOfCurrentUser(birthdayDateController.selectedDate);
      Get.snackbar('Successful', 'The birthday update was successful.');
    } on Exception {
      return Future.error(
          'The birthday could not be updated. Please try again later.');
    }

    return true;
  }

  Future<bool> updateNeighbourhoodMemberSinceOfCurrentUser() async {
    try {
      await userPublicInfoRepository
          .updateNeighbourhoodMemberSinceOfCurrentUser(
              neighbourhoodMemberSinceController.selectedDate);
    } on Exception {
      return Future.error(
          'The date since you joined the neighborhood could not be updated. Please try again later.');
    }

    return true;
  }

  final List<String> _interests = <String>[];

  void initializeInterests(List<String>? interestsList) {
    _interests.clear();
    if (interestsList != null && interestsList.isNotEmpty) {
      _interests.addAll(interestsList);
    }
  }

  List<String> getInterests() {
    return _interests;
  }

  addInterest(String interest) {
    _interests.add(interest);
    update(['EditProfileInterestTags']);
  }

  removeInterest(String interest) {
    _interests.remove(interest);
    update(['EditProfileInterestTags']);
  }

  void showTagDialog(BuildContext context) async {
    final String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TagDialog();
      },
    );

    addInterest(result);
  }

  Future<bool> updateInterestsOfCurrentUser() async {
    try {
      await userPublicInfoRepository.updateInterestsOfCurrentUser(_interests);
    } on Exception {
      return Future.error(
          'Your interests could not be updated. Please try again later.');
    }

    return true;
  }

  final List<String> _offers = <String>[];

  void initializeOffer(List<String>? offersList) {
    _offers.clear();
    if (offersList != null) {
      _offers.addAllIf(offersList.isNotEmpty, offersList);
    }
  }

  List<String> getOffers() {
    return _offers;
  }

  addOffer(String offer) {
    _offers.add(offer);
    update(['EditProfileOfferTags']);
  }

  removeOffer(String offer) {
    _offers.remove(offer);
    update(['EditProfileOfferTags']);
  }

  void showOfferTagDialog(BuildContext context) async {
    final String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TagDialog();
      },
    );

    addOffer(result);
  }

  Future<bool> updateOffersOfCurrentUser() async {
    try {
      await userPublicInfoRepository.updateOffersOfCurrentUser(_offers);
    } on Exception {
      return Future.error(
          'The field could not be updated. Please try again later.');
    }

    return true;
  }
}
