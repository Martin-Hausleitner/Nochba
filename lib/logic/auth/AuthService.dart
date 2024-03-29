import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nochba/logic/auth/AuthExceptionHandler.dart';
import 'package:nochba/logic/auth/AuthResultStatus.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/Token.dart';
import 'package:nochba/logic/models/UserPrivateInfoAddress.dart';
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
import 'package:nochba/logic/repositories/UserPrivateInfoAddressRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';

class AuthService extends ResourceAccess {
  AuthService(super.resourceContext) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _firebaseUser = user;
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<bool> isUserRegistered(String email) async {
    try {
      var result =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (error) {
      print('Error while checking if user is registered: $error');
      return false;
    }
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

  // Future<AuthResultStatus> signIn2(String email, String password) async {
  //   if ((email.isEmpty && !GetUtils.isEmail(email)) ||
  //       (password.isEmpty && password.length < 6)) {
  //     return AuthResultStatus.invalidEmailAndPassword;
  //   }

  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);

  //     return AuthResultStatus.successful;
  //   } on FirebaseAuthException catch (e) {
  //     return AuthExceptionHandler.handleException(e);
  //   }
  // }

  //////

  Future<bool> signUpWithEmail(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());

    return true;
  }

  Future<bool> createUser(String firstName, String lastName,
      ImageFile? imageFile, bool showLastNameInitialOnly) async {
    if (firstName.isEmpty || lastName.isEmpty) {
      return false;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final uid = currentUser.uid;

      String imageUrl = '';
      if (imageFile != null && !imageFile.isClear()) {
        final storageService = Get.find<StorageService>();

        imageUrl =
            await storageService.uploadProfileImageToStorage(imageFile.file!);
      }

      final userRepository = Get.find<UserRepository>();
      await userRepository.insert(
        models.User(
            id: uid,
            firstName: '',
            lastName: '',
            fullName: '',
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

      final bookMarkRepository = Get.find<BookMarkRepository>();
      await bookMarkRepository.insert(
          BookMark(id: bookMarkRepository.reference, posts: []),
          nexus: [uid]);

      final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();
      await userPublicInfoRepository.insert(
          UserPublicInfo(id: userPublicInfoRepository.reference),
          nexus: [uid]);

      // final pushNotificationService = PushNotificationService();
      // final token = await pushNotificationService.getToken();

      // final tokenRepository = Get.find<TokenRepository>();
      // await tokenRepository.insert(Token(
      //     id: uid,
      //     token: token ?? '',
      //     createdAt: FieldValue.serverTimestamp()));
    } on Exception catch (e) {
      print('Fehler beim erzeugen des Users: ' + e.toString());
      rethrow;
    }

    return true;
  }

  Future<bool> addUserAddress(
      String street, String streetNumber, String city, String zip) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
      'checkAddress',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );

    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'street': street,
      'streetNumber': streetNumber,
      'city': city,
      'zip': zip,
    });

    //   final currentUser = FirebaseAuth.instance.currentUser;
    //   if (currentUser == null) {
    //     return false;
    //   }

    //   final uid = currentUser.uid;

    //   final userPrivateInfoAddressRepository =
    //       Get.find<UserPrivateInfoAddressRepository>();
    //   await userPrivateInfoAddressRepository.insert(
    //       UserPrivateInfoAddress(
    //           id: userPrivateInfoAddressRepository.reference,
    //           street: street,
    //           streetNumber: streetNumber,
    //           city: city,
    //           zip: zip),
    //       nexus: [uid]);

    return result.data as bool;
  }

  Future<bool> deleteUserAddress() async {
    if (_firebaseUser == null) {
      return false;
    }

    final userPrivateInfoAddressRepository =
        Get.find<UserPrivateInfoAddressRepository>();
    userPrivateInfoAddressRepository
        .delete(userPrivateInfoAddressRepository.reference, nexus: [uid]);

    return true;
  }

  Future<bool> addUserCoordinates() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final uid = currentUser.uid;

      final position = await getLocationData();

      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'checkAddressWithDeviceLocation',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 20),
        ),
      );

      final userPrivateInfoAddressRepository =
          Get.find<UserPrivateInfoAddressRepository>();
      final address = await userPrivateInfoAddressRepository
          .get(userPrivateInfoAddressRepository.reference, nexus: [uid]);

      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'address':
            '${address!.street} ${address.streetNumber}, ${address.zip} ${address.city}, Austria',
        'deviceLongitudeCoordinate': position.longitude,
        'deviceLatitudeCoordinate': position.latitude,
      });

      // final HttpsCallableResult result = await callable.call(<String, dynamic>{
      //   'address': 'Wüstenrotstrasse 11, 4020 Linz, Austria',
      //   'deviceLongitudeCoordinate': 14.3029918272796,
      //   'deviceLatitudeCoordinate': 48.30083402501781,
      // });

      // final userInternInfoAddressRepository =
      //     Get.find<UserInternInfoAddressRepository>();
      // await userInternInfoAddressRepository.insert(
      //     UserInternInfoAddress(
      //         id: userInternInfoAddressRepository.reference,
      //         position: GeoFirePoint(position.latitude, position.longitude)),
      //     nexus: [uid]);
    } on Exception catch (e) {
      if (e.toString().contains('[firebase_functions/invalid-argument]')) {
        Get.snackbar('Fehler',
            'Die Handy-Position stimmt nicht mit der Adresse überein.');
      } else {
        Get.snackbar('Fehler', e.toString());
      }
      rethrow;
    }

    return true;
  }

  Future<bool> checkVerificationCode(String verificationCode) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final uid = currentUser.uid;

      final HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'checkVerificationCode',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 10),
        ),
      );

      final userPrivateInfoAddressRepository =
          Get.find<UserPrivateInfoAddressRepository>();
      final address = await userPrivateInfoAddressRepository
          .get(userPrivateInfoAddressRepository.reference, nexus: [uid]);

      final response = await callable.call({
        'verificationCode': verificationCode,
        'address':
            '${address!.street} ${address.streetNumber}, ${address.zip} ${address.city}, Austria',
      });

      // final HttpsCallableResult result = await callable.call(<String, dynamic>{
      //   'address': 'Wüstenrotstrasse 11, 4020 Linz, Austria',
      //   'deviceLongitudeCoordinate': 14.3029918272796,
      //   'deviceLatitudeCoordinate': 48.30083402501781,
      // });

      // final userInternInfoAddressRepository =
      //     Get.find<UserInternInfoAddressRepository>();
      // await userInternInfoAddressRepository.insert(
      //     UserInternInfoAddress(
      //         id: userInternInfoAddressRepository.reference,
      //         position: GeoFirePoint(position.latitude, position.longitude)),
      //     nexus: [uid]);
    } on Exception catch (e) {
      Get.snackbar('Fehler', e.toString());
      rethrow;
    }

    return true;
  }

  Future<bool> deleteAccountAndUserData() async {
    if (_firebaseUser == null) {
      return false;
    }

    final userRepository = Get.find<UserRepository>();
    await userRepository.delete(uid);
    await _firebaseUser!.delete();

    return true;
  }

  Future<bool> deleteAccount() async {
    if (_firebaseUser == null) {
      return false;
    }

    await _firebaseUser!.delete();

    return true;
  }

  Future<bool> deleteUserData() async {
    if (_firebaseUser == null) {
      return false;
    }

    final userRepository = Get.find<UserRepository>();
    userRepository.delete(uid);

    return true;
  }

  /////

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

      final userRepository = Get.find<UserRepository>();
      await userRepository.insert(
        models.User(
            id: uid,
            firstName: '',
            lastName: '',
            fullName: '',
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

      final bookMarkRepository = Get.find<BookMarkRepository>();
      await bookMarkRepository.insert(
          BookMark(id: bookMarkRepository.reference, posts: []),
          nexus: [uid]);

      final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();
      await userPublicInfoRepository.insert(
          UserPublicInfo(id: userPublicInfoRepository.reference),
          nexus: [uid]);

      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'checkAddressWithDeviceLocation',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 20),
        ),
      );

      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'address': 'Limesstraße 14, 4060 Leonding, Austria',
        'deviceLongitudeCoordinate': 14.251555409469784,
        'deviceLatitudeCoordinate': 48.268363550000004,
      });

      // final position = await getLocationData();
      // final userInternInfoAddressRepository =
      //     Get.find<UserInternInfoAddressRepository>();
      // await userInternInfoAddressRepository.insert(
      //     UserInternInfoAddress(
      //         id: userInternInfoAddressRepository.reference,
      //         position: GeoFirePoint(position.latitude, position.longitude)),
      //     nexus: [uid]);

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

  String? getEmailOfCurrentUser() {
    if (_firebaseUser == null) {
      return null;
    }

    return _firebaseUser!.email;
  }

  Future<void> updateEmailOfCurrentUser(String email) async {
    if (_firebaseUser == null) {
      return;
    }

    return await _firebaseUser!.updateEmail(email.trim());
  }

  Future<void> updatePasswordOfCurrentUser(String password) async {
    if (_firebaseUser == null) {
      return;
    }

    return await _firebaseUser!.updatePassword(password.trim());
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
