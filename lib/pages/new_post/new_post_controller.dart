import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/data_access.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/views/new_post/tag_dialog.dart';

import '../../logic/models/post.dart';
import '../../shared/views/bottom_sheet_close_save_view.dart';

class NewPostController extends GetxController {
  final pageController = PageController(initialPage: 0);

  final Rx<CategoryOptions> _category = CategoryOptions.None.obs;
  final Rx<CategoryOptions> _subcategory = CategoryOptions.None.obs;
  final RxList<CategoryOptions> _subcategoriesForDisplay =
      <CategoryOptions>[CategoryOptions.Other].obs;

  CategoryOptions get category => _category.value;
  CategoryOptions get subcategory => _subcategory.value;
  List<CategoryOptions> get subcategoriesForDisplay => _subcategoriesForDisplay;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxList<String> _tags = <String>[].obs;

  List<String> get tags => _tags;

  String imageName = '';
  Uint8List? image;

  final dataAccess = Get.find<DataAccess>();

  updateCategory(CategoryOptions newCategory) {
    if (newCategory == CategoryModul.message) {
      _category.value = CategoryModul.message;
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfMessage;

      pageController.jumpToPage(1);
    } else if (newCategory == CategoryModul.search) {
      _category.value = CategoryModul.search;
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfSearch;

      pageController.jumpToPage(1);
    } else if (newCategory == CategoryModul.lending) {
      _category.value = CategoryModul.lending;
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfLending;

      pageController.jumpToPage(2);
    } else if (newCategory == CategoryModul.event) {
      _category.value = CategoryModul.event;
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfEvent;

      pageController.jumpToPage(2);
    }

    /*pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );*/
  }

  // create JumpToPage which pageController.jumpToPage(2);
  jumpToPage(int page) {
    pageController.jumpToPage(page);
  }

  jumpToStartPage() {
    pageController.jumpToPage(0);
  }

  updateSubcategory(CategoryOptions newSubcategory) {
    if (CategoryModul.subCategories.contains(newSubcategory) ||
        newSubcategory == CategoryOptions.Other) {
      _subcategory.value =
          newSubcategory == CategoryOptions.Other ? category : newSubcategory;

      pageController.jumpToPage(2);
    }
  }

  jumpBack() {
    if (_subcategory.value == CategoryOptions.None) {
      _category.value = CategoryOptions.None;
      pageController.jumpToPage(0);
    } else {
      _subcategory.value = CategoryOptions.None;

      pageController.jumpToPage(1);
    }

    titleController.clear();
    descriptionController.clear();
    _tags.clear();
    image = null;
    imageName = '';
    update();
  }

  addTag(String tag) {
    _tags.add(tag);
  }

  removeTag(String tag) {
    _tags.remove(tag);
  }

  void showTagDialog(BuildContext context) async {
    final String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TagDialog();
      },
    );

    addTag(result);
  }

  //ceate a function showTagBottomsheet which opens a  showModalBottomSheet<void>(

  // showTagBottomsheet(BuildContext context) async {
  //   final String result = await showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return TagBottomSheet();
  //     },
  //   );
  //   addTag(result);
  // }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Pick an image'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.camera);
                },
              )
            ],
          );
        });
  }

  pickImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource);

    if (file != null) {
      imageName = file.path.split('/').last;
      image = await file.readAsBytes();
      update();
    }
  }

  deleteImage() {
    image = null;
    imageName = '';
    update();
  }

  final postRepository = Get.find<PostRepository>();

  addPost() async {
    //final isValid = formKey.currentState!.validate();
    if (/*!isValid ||*/ category == CategoryOptions.None) return;

    final imageUrl = image == null
        ? ''
        : await dataAccess.uploadPostImageToStorage(imageName, image!);

    final post = Post(
      user: FirebaseAuth.instance.currentUser!.uid,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      imageUrl: imageUrl,
      createdAt: Timestamp.now(),
      category: subcategory != CategoryOptions.None
          ? subcategory.name.toString()
          : category.name.toString(),
      tags: tags,
      liked: [],
    );

    try {
      postRepository.insert(post);
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar('Error', e.message!);
    }

    titleController.clear();
    descriptionController.clear();
    _tags.clear();
    image = null;
    imageName = '';
    _category.value = CategoryOptions.None;
    _subcategory.value = CategoryOptions.None;
    _subcategoriesForDisplay.clear();
    update();

    pageController.nextPage(
        duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
  }

  @override
  void dispose() {
    pageController.dispose();
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}

// class TagBottomSheet extends StatelessWidget {
//   const TagBottomSheet({
//     Key? key,
//   }) : super(key: key);
//   TextEditingController textController = TextEditingController();


//   @override
//   Widget build(BuildContext context) {
//     return BottomSheetCloseSaveView(
//                         onSave: () {},
//                         children: [
//                           // ad a counter with + an- buttons
//                           Row(
//                             children: [
//                               Text('0'),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(FlutterRemix.add_line),
//                               ),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(FlutterRemix.subtract_line),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//   }
// }
