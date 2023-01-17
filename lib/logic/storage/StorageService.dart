import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/ImageFile.dart';

class StorageService extends GetxService {
  Future<String> uploadPostImageToStorage(
      String imageName, Uint8List file) async {
    final authService = Get.find<AuthService>();

    if (authService.uid.isEmpty) {
      return '';
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('posts/${authService.uid}/$imageName');
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<ImageFile?> downloadPostImageFromStorage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return null;
    }
    Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);

    ImageFile imageFile = ImageFile();
    imageFile.name = ref.name;
    imageFile.file = await ref.getData();

    return imageFile;
  }

  Future<String> downloadPostImageNameFromStorage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return '';
    }
    Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);

    return ref.name;
  }

  Future<void> deletePostImageFromStorage(String imageName) async {
    final authService = Get.find<AuthService>();

    if (authService.uid.isNotEmpty && imageName.isNotEmpty) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('posts/${authService.uid}/$imageName');
      return await ref.delete();
    }
  }

  Future<String> uploadProfileImageToStorage(Uint8List file) async {
    final authService = Get.find<AuthService>();

    if (authService.uid.isEmpty) {
      return '';
    }

    Reference ref =
        FirebaseStorage.instance.ref().child('profile/${authService.uid}');
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  /*Future<String> uploadProfileImageToStorage(Uint8List file) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile/${FirebaseAuth.instance.currentUser!.uid}');
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }*/
}
