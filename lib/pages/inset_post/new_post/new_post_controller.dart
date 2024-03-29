import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';
import 'package:nochba/pages/inset_post/inset_post_controller.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_page.dart';

class NewPostController extends InsetPostController {
  final pageController = PageController(initialPage: 0);

  final RxList<CategoryOptions> _subcategoriesForDisplay =
      <CategoryOptions>[CategoryOptions.Other].obs;

  List<CategoryOptions> get subcategoriesForDisplay => _subcategoriesForDisplay;

  updateCategory(CategoryOptions newCategory) {
    if (newCategory == CategoryModul.message) {
      setCategory(CategoryModul.message);
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfMessage;

      pageController.jumpToPage(1);
    } else if (newCategory == CategoryModul.search) {
      setCategory(CategoryModul.search);
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfSearch;

      pageController.jumpToPage(1);
    } else if (newCategory == CategoryModul.lending) {
      setCategory(CategoryModul.lending);
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfLending;

      pageController.jumpToPage(2);
    } else if (newCategory == CategoryModul.event) {
      setCategory(CategoryModul.event);
      _subcategoriesForDisplay.value = CategoryModul.subCategoriesOfEvent;

      pageController.jumpToPage(2);
    }

    refreshCategoryName();
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
    if (CategoryModul.subCategories.contains(newSubcategory)) {
      setSubCategory(newSubcategory);

      refreshCategoryName();
      pageController.jumpToPage(2);
    }
  }

  jumpBack() {
    if (subCategory == CategoryOptions.None) {
      setCategory(CategoryOptions.None);

      pageController.jumpToPage(0);
    } else {
      setSubCategory(CategoryOptions.None);

      pageController.jumpToPage(1);
    }

    clear(alsoCategory: false);
    refreshCategoryName();
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

  final storageService = Get.find<StorageService>();
  final postRepository = Get.find<PostRepository>();

  addPost() async {
    if (category == CategoryOptions.None) {
      Get.snackbar(
          'Posting not possible', 'Please select a category for your post');
      return;
    } else if (!formKey.currentState!.validate()) {
      Get.snackbar(
          'Posting not possible', 'Please fill out the input fields correctly');
      return;
    }

    if (category == CategoryOptions.Event) {
      if (!eventKey.currentState!.validate()) {
        Get.snackbar('Posting not possible',
            'Please fill out the input fields correctly');
        return;
      }
      if (eventTime != null) {
        if (eventTime!.length != 2) {
          Get.snackbar('Posting not possible',
              'Please enter a valid date for the event');
          return;
        } else if (eventTime![0].isAfter(eventTime![1])) {
          Get.snackbar('Posting not possible',
              'The start date must be before the end date');
          return;
        }
      } else {
        Get.snackbar(
            'Posting not possible', 'Please enter a valid date for the event');
        return;
      }
    }

    isLoading = true;
    update();

    try {
      final imageUrl = image == null
          ? ''
          : await storageService.uploadPostImageToStorage(imageName, image!);

      final post = Post(
        uid: FirebaseAuth.instance.currentUser!.uid,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imageUrl: imageUrl,
        createdAt: Timestamp.now(),
        category: subCategory != CategoryOptions.None
            ? subCategory.name.toString()
            : category.name.toString(),
        tags: [...tags..sort()],
        likes: 0,
        range: sliderValue,
        eventLocation: category == CategoryOptions.Event
            ? eventLocationController.text.trim()
            : null,
        eventBeginTime: category == CategoryOptions.Event
            ? Timestamp.fromDate(eventTime![0])
            : null,
        eventEndTime: category == CategoryOptions.Event
            ? Timestamp.fromDate(eventTime![1])
            : null,
      );

      await postRepository.insert(post);
      postId = post.id;

      clear();
      _subcategoriesForDisplay.clear();

      pageController.nextPage(
          duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
    } on FirebaseAuthException catch (e) {
      print(e);
      //Get.snackbar('Error', e.message!);
      Get.snackbar(
          'Posting went wrong', 'Please check your internet connection');
    }
  }

  String? postId;
  void pushEditPostView() {
    if (postId != null) {
      Get.to(() => EditPostPage(
            postId: postId!,
          ));
    }
  }

  void jumpBackToStartPage() {
    postId = null;
    clear();
    jumpToStartPage();
  }

  @override
  void dispose() {
    pageController.dispose();

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
