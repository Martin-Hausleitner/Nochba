import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/post.dart';

class DataAccess extends GetxService {
    final CollectionReference<Map<String, dynamic>> userdataCol = FirebaseFirestore.instance.collection('userdata');
    final CollectionReference<Map<String, dynamic>> postCol = FirebaseFirestore.instance.collection('posts');
    final CollectionReference<Map<String, dynamic>> categoryCol = FirebaseFirestore.instance.collection('categories');

    Future<List<Category>> getCategories() async {
    try {
      final snapshots = await FirebaseFirestore.instance.collection('categories').get();
      
      return snapshots.docs.map((e) => Category.fromJson(e.data())).toList();
    } catch(e) {
      print(e);
      return List.empty();
    }    
  }

  Stream<List<Post>> getPosts() => postCol
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

}