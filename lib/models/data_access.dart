import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/post.dart';
import 'package:locoo/models/user.dart' as models;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class DataAccess extends GetxService {
    final CollectionReference<Map<String, dynamic>> userdataCol = FirebaseFirestore.instance.collection('users');
    final CollectionReference<Map<String, dynamic>> postCol = FirebaseFirestore.instance.collection('posts');
    final CollectionReference<Map<String, dynamic>> categoryCol = FirebaseFirestore.instance.collection('categories');

    /*Future<List<Category>> getCategories() async {
    try {
      final snapshots = await FirebaseFirestore.instance.collection('categories').get();
      
      return snapshots.docs.map((e) => Category.fromJson(e.data())).toList();
    } catch(e) {
      print(e);
      return List.empty();
    }    
  }*/

  Stream<List<Post>> getPosts() => postCol
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Future<String> uploadPostImageToStorage(String imageName, Uint8List file) async {
    Reference ref = FirebaseStorage.instance.ref().child('posts/$imageName');
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadProfileImageToStorage(Uint8List file) async {
    Reference ref = FirebaseStorage.instance.ref().child('profile').child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<models.User?> getUser(String uid) async {
    try {
      final snapshot = await userdataCol.doc(uid).get();

      if(snapshot.exists) {
        return models.User.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<types.User?> getChatUser(String uid) async {
    try {
      final snapshot = await userdataCol.doc(uid).get();

      if(snapshot.exists) {
        return types.User.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

}