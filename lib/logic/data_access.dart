import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/models/Notification.dart';
import 'package:locoo/logic/models/bookmark.dart';
import 'package:locoo/logic/models/category.dart';
import 'package:locoo/logic/models/post.dart';
import 'package:locoo/logic/models/user.dart' as models;
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:locoo/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart' as types;

class DataAccess extends GetxService {
    final CollectionReference<Map<String, dynamic>> userdataCol = FirebaseFirestore.instance.collection('users');
    final CollectionReference<Map<String, dynamic>> postCol = FirebaseFirestore.instance.collection('posts');
    final CollectionReference<Map<String, dynamic>> notificationCol = FirebaseFirestore.instance.collection('notifications');
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

  Stream<List<Post>> getPostsOfUser(String uid) => postCol
        .where('user', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Future<List<Post>> getSavedPostsOfCurrentUser() async {
    try {

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot1 = await userdataCol.doc(uid).collection('bookmarks').doc(uid).get();

      if(snapshot1.exists) {

        final posts = BookMark.fromJson(snapshot1.data()!).posts;
        final snapshot2 = await postCol.where('id', whereIn: posts).get();

        if(snapshot2.docs.isNotEmpty) {
          return snapshot2.docs.map((e) => Post.fromJson(e.data())).toList();
        } else {
          return List.empty();
        }
      } else {
        return List.empty();
      }
    } on Exception catch (e) {
      print(e);
      return List.empty();
    }
  }

  /*Future<BookMark?> getBookMarkOfCurrentUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await userdataCol.doc(uid).collection('bookmarks').doc(uid).get();

      if(snapshot.exists) {
        return BookMark.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    } on Exception catch(e) {
      print(e);
      return null;
    }
  }

  Stream<BookMark?> getBookMarkOfCurrentUser() {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      Stream<BookMark?> result = const Stream.empty();
      userdataCol.doc(uid).collection('bookmarks').doc(uid).get().then((snapshot) => {
        if(snapshot.exists) {
          result = Stream.value(BookMark.fromJson(snapshot.data()!))
        } else {
          result = Stream.value(null)
        }
      });
      return result;
    } on Exception catch(e) {
      print(e);
      return Stream.value(null);
    }
  }*/

  Stream<BookMark?> getBookMarkOfCurrentUser() => userdataCol
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('bookmarks')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((doc) {
        if(doc.exists) {
          return BookMark.fromJson(doc.data()!);
        } else {
          return null;
        }
      });


  Future<bool> updateBookMark(BookMark bookMark) async {
    try {
      await userdataCol.doc(bookMark.id).collection('bookmarks').doc(bookMark.id).update(bookMark.toJson());
      return true;
    } on Exception catch(e) {
      print(e);
      return false;
    }
  }

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

  Stream<List<Notification>> getNotifications() => notificationCol
        .where('toUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Notification.fromJson(doc.data())).toList());

  Future<bool> sendNotification(String toUser, NotificationType type, {String? postId}) async {
    if(toUser.isEmpty) {
      return false;
    }
    if(type == NotificationType.chatRequest && (postId == null || postId.isEmpty)) {
      return false;
    }
 
    final notification = Notification(
      fromUser: FirebaseAuth.instance.currentUser!.uid,
      toUser: toUser,
      type: type,
      postId: postId,
      createdAt: Timestamp.now(),
    );

    final snapshot = await notificationCol
    .where('fromUser', isEqualTo: notification.fromUser)
    .where('toUser', isEqualTo: notification.toUser)
    .where('postId', isEqualTo: notification.postId)
    .get();

    if(snapshot.docs.isEmpty) {
      try {
        final doc = notificationCol.doc();
        notification.id = doc.id;
        await doc.set(notification.toJson());
        return true;
      } on FirebaseException catch (e) {
        print(e.message);
        return false;
      }
    } else {
      return false;
    }
    
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      await notificationCol.doc(notificationId).delete();
      return true;
    } on FirebaseException catch(e) {
      return false;
    }
  }

}