import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';
import 'package:nochba/pages/inset_post/Inset_post_controller.dart';

class NewPostController extends InsetPostController {
  final pageController = PageController(initialPage: 0);

  final Rx<CategoryOptions> _category = CategoryOptions.None.obs;
  final Rx<CategoryOptions> _subcategory = CategoryOptions.None.obs;
  final RxList<CategoryOptions> _subcategoriesForDisplay =
      <CategoryOptions>[CategoryOptions.Other].obs;

  CategoryOptions get category => _category.value;
  CategoryOptions get subcategory => _subcategory.value;
  List<CategoryOptions> get subcategoriesForDisplay => _subcategoriesForDisplay;

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

    clear();
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
    //final isValid = formKey.currentState!.validate();
    if (/*!isValid ||*/ category == CategoryOptions.None) return;

    try {
      final imageUrl = image == null
          ? ''
          : await storageService.uploadPostImageToStorage(imageName, image!);
      final post = Post(
        user: FirebaseAuth.instance.currentUser!.uid,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imageUrl: imageUrl,
        createdAt: Timestamp.now(),
        category: subcategory != CategoryOptions.None
            ? subcategory.name.toString()
            : category.name.toString(),
        tags: [...tags..sort()],
        liked: [],
      );

      postRepository.insert(post);
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar('Error', e.message!);
    }

    clear();
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
