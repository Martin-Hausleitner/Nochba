import 'package:firebase_auth/firebase_auth.dart';
import 'package:locoo/logic/models/bookmark.dart';
import 'package:locoo/logic/repositories/ResourceAccess.dart';
import 'package:locoo/logic/models/user.dart' as models;

class AuthService extends ResourceAccess {
  AuthService(super.resourceContext);

  Future<bool> signIn(String email, String password) async {
    if(email.isEmpty || password.isEmpty) {
      return false;
    }

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    return true;
  }

  Future<bool> signUp(String email, String password, String firstName, String lastName) async {
    if(email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      return false;
    }

    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    final uid = cred.user!.uid;

    final userResource = loadResource<models.User>();
    userResource.insert(models.User(
      id: uid,
      firstName: firstName,
      lastName: lastName,
      imageUrl: 'https://i.pravatar.cc/300?u=$email',
      role: models.Role.user,
      metadata: const {'value': ''}
    ),);

    final bookMarkResource = loadResource<BookMark>();
    bookMarkResource.insert(BookMark(id: uid, posts: []), nexus: [uid]);

    return true;
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}