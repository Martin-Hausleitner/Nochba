import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:locoo/logic/flutter_firebase_chat_core-1.6.3/flutter_firebase_chat_core.dart' as chat;
import 'package:get/get.dart';

//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:locoo/logic/models/user.dart' as models;
import 'package:locoo/logic/models/bookmark.dart';


class AuthAccess extends GetxService {
  Future<bool> signIn(String email, String password) async {
    if(email.isEmpty || password.isEmpty) {
      return false;
    }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return true;
    } on Exception catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String firstName, String lastName) async {
    if(email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      return false;
    }
    try{
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      final uid = cred.user!.uid;
      await chat.FirebaseChatCore.instance.createUserInFirestore(
        models.User(
          firstName: firstName,
          id: uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$email',
          lastName: lastName,
          role: models.Role.user,
          metadata: const {'value': ''}
        ),
      );

      final bookMark = BookMark(id: uid, posts: []);
      print(bookMark.id);
      await FirebaseFirestore.
                          instance.
                          collection('users').
                          doc(uid).
                          collection('bookmarks').
                          doc(uid).
                          set(bookMark.toJson());

      return true;
    } on Exception catch(e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }
}