import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/views/new_post/tag_dialog.dart';

import '../../models/post.dart';

class NewPostController extends GetxController {
  final Rx<CategoryOptions> _category = CategoryOptions.None.obs;
  final Rx<CategoryOptions> _subcategory = CategoryOptions.None.obs;

  CategoryOptions get category => _category.value;
  CategoryOptions get subcategory => _subcategory.value;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  RxList<String> tags = <String>[].obs;

  Uint8List? image;

  updateCategory(CategoryOptions newCategory) {
    _category.value = newCategory;
  }

  updateSubcategory(CategoryOptions newSubcategory) {
    _subcategory.value = newSubcategory;
  }

  addTag(String tag) {
    tags.add(tag);
  }

  removeTag(String tag) {
    tags.remove(tag);    Get.snackbar('Moin', 'Seas');
  }

  void showTagDialog(BuildContext context) async {

    final String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TagDialog();
      },
    );

    addTag(result);
  }

  selectImage(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Pick an image'),
            onPressed: () async {
              Navigator.of(context).pop();
              image = await pickImage(ImageSource.gallery);
            },
          )
        ],
      );
    });
  }

  Future<String> uploadImageToStorage(String childname, Uint8List file, bool isPost) async {
    Reference ref = FirebaseStorage.instance.ref().child(childname).child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  pickImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource);

    if(file != null) {
      return await file.readAsBytes();
    }
  }



  addPost() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid || category == CategoryOptions.None) return;

    final imageUrl = image == null ? '' : await uploadImageToStorage('post', image!, true);

    final post = Post(
      user: FirebaseAuth.instance.currentUser!.uid,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      imageUrl: imageUrl,
      createdAt: Timestamp.now(),
      category: subcategory != CategoryOptions.None ? subcategory.name.toString() : category.name.toString(),
      tags: tags,
      liked: [],
    );

    try{
      final doc = FirebaseFirestore.instance.collection('posts').doc();
      post.id = doc.id;
      doc.set(post.toJson());    
    } on FirebaseAuthException catch(e) {
      print(e);
      Get.snackbar('Error', e.message!);
    }

    titleController.clear();
    descriptionController.clear();
  }

  @override void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
