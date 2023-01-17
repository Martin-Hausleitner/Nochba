import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthExceptionHandler.dart';
import 'package:nochba/logic/auth/AuthResultStatus.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/Token.dart';
import 'package:nochba/logic/models/UserInternInfoAddress.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/UserPrivateInfoSettings.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/push_notifications.dart/PushNotificationService.dart';
import 'package:nochba/logic/register/get_location_data.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/ResourceAccess.dart';
import 'package:nochba/logic/models/user.dart' as models;
import 'package:nochba/logic/repositories/TokenRepository.dart';
import 'package:nochba/logic/repositories/UserInternInfoAddressRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';

class AuthService extends ResourceAccess {
  AuthService(super.resourceContext) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _firebaseUser = user;
    });
  }

  User? _firebaseUser = FirebaseAuth.instance.currentUser;
  String get uid => _firebaseUser != null ? _firebaseUser!.uid : '';

  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return true;
  }

  Future<AuthResultStatus> signIn2(String email, String password) async {
    if ((email.isEmpty && !GetUtils.isEmail(email)) ||
        (password.isEmpty && password.length < 6)) {
      return AuthResultStatus.invalidEmailAndPassword;
    }

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return AuthResultStatus.successful;
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    }
  }

  Future<bool> signUp(
      String email,
      String password,
      String firstName,
      String lastName,
      ImageFile? imageFile,
      bool showLastNameInitialOnly) async {
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      return false;
    }

    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = cred.user!.uid;
      String imageUrl = 'https://i.pravatar.cc/300?u=$email';
      if (imageFile != null && !imageFile.isClear()) {
        final storageService = Get.find<StorageService>();

        imageUrl =
            await storageService.uploadProfileImageToStorage(imageFile.file!);
      }

      final userResource = loadResource<models.User>();
      await userResource.insert(
        models.User(
            id: uid,
            firstName: '',
            lastName: '',
            imageUrl: imageUrl,
            role: models.Role.user,
            metadata: const {'value': ''}),
      );

      final userPrivateInfoNameRepository =
          Get.find<UserPrivateInfoNameRepository>();
      await userPrivateInfoNameRepository.insert(
          UserPrivateInfoName(
              id: userPrivateInfoNameRepository.reference,
              firstName: firstName,
              lastName: lastName),
          nexus: [uid]);

      final userPrivateInfoSettingsRepository =
          Get.find<UserPrivateInfoSettingsRepository>();
      await userPrivateInfoSettingsRepository.insert(
          UserPrivateInfoSettings(
              id: userPrivateInfoSettingsRepository.reference,
              permReqBeforeChat: false,
              lastNameInitialOnly: showLastNameInitialOnly),
          nexus: [uid]);

      final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();
      await userPublicInfoRepository.insert(
          UserPublicInfo(id: userPublicInfoRepository.reference),
          nexus: [uid]);

      final bookMarkRepository = Get.find<BookMarkRepository>();
      await bookMarkRepository.insert(
          BookMark(id: bookMarkRepository.reference, posts: []),
          nexus: [uid]);

      final position = await getLocationData();

      final userInternInfoAddressRepository =
          Get.find<UserInternInfoAddressRepository>();
      await userInternInfoAddressRepository.insert(
          UserInternInfoAddress(
              id: userInternInfoAddressRepository.reference,
              position: GeoFirePoint(position.latitude, position.longitude)),
          nexus: [uid]);

      // final pushNotificationService = PushNotificationService();
      // final token = await pushNotificationService.getToken();

      // try {
      //   final tokenRepository = Get.find<TokenRepository>();
      //   tokenRepository.insert(Token(
      //       id: uid,
      //       token: token ?? '',
      //       createdAt: FieldValue.serverTimestamp()));
      // } catch (e) {
      //   print('Hier ist der Fehler | ' + e.toString());
      // }

    } on Exception catch (e) {
      Get.snackbar('Error', e.toString());
    }

    return true;
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
