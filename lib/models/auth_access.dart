import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


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
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: firstName,
          id: cred.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$email',
          lastName: lastName,
        ),
      );
      return true;
    } on Exception catch(e) {
      print(e);
      return false;
    }
  }
}