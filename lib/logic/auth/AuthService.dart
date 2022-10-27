import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthExceptionHandler.dart';
import 'package:nochba/logic/auth/AuthResultStatus.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/repositories/ResourceAccess.dart';
import 'package:nochba/logic/models/user.dart' as models;

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
      String email, String password, String firstName, String lastName) async {
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      return false;
    }

    final cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final uid = cred.user!.uid;

    final userResource = loadResource<models.User>();
    await userResource.insert(
      models.User(
          id: uid,
          firstName: firstName,
          lastName: lastName,
          imageUrl: 'https://i.pravatar.cc/300?u=$email',
          role: models.Role.user,
          metadata: const {'value': ''}),
    );

    final userPublicInfoResource = loadResource<UserPublicInfo>();
    await userPublicInfoResource.insert(UserPublicInfo(id: uid), nexus: [uid]);

    final bookMarkResource = loadResource<BookMark>();
    await bookMarkResource.insert(BookMark(id: uid, posts: []), nexus: [uid]);

    return true;
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
