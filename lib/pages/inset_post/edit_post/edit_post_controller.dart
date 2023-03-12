import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/ImageFile.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/storage/StorageService.dart';
import 'package:nochba/pages/inset_post/inset_post_controller.dart';

class EditPostController extends InsetPostController {
  Post? oldPost;
  ImageFile? imageFileOfOldPost;

  final storageService = Get.find<StorageService>();
  final postRepository = Get.find<PostRepository>();

  Future<bool> initializePage(String postId) async {
    clear();

    oldPost = await postRepository.get(postId);

    titleController.text = oldPost!.title;
    descriptionController.text = oldPost!.description;

    CategoryOptions tmp =
        CategoryModul.getCategoryOptionByName(oldPost!.category);
    if (CategoryModul.isMainCategory(tmp)) {
      setCategory(tmp);
    } else if (CategoryModul.isSubCategory(tmp)) {
      setCategory(CategoryModul.getMainCategoryOfSubCategory(tmp));
      setSubCategory(tmp);
    }
    onSliderValueChanged(oldPost!.range);
    update();
    //Get.snackbar(category.name, subCategory.name);

    refreshCategoryName();
    addTags(oldPost!.tags);

    imageFileOfOldPost =
        await storageService.downloadPostImageFromStorage(oldPost!.imageUrl);
    if (imageFileOfOldPost != null) {
      setImageFile(imageFileOfOldPost!);
    }

    return true;
  }

  List<CategoryOptions> get mainCategories => CategoryModul.mainCategories;
  List<CategoryOptions> getSubCategoriesOf(CategoryOptions categoryOptions) =>
      CategoryModul.getSubCategoriesOfMainCategory(categoryOptions);

  List<CategoryOptions> getSubCategoriesOfSelectedCategory() {
    return CategoryModul.isMainCategory(category) == true
        ? CategoryModul.getSubCategoriesOfMainCategory(category)
        : [];
  }

  selectCategory(CategoryOptions categoryOption) {
    if (CategoryModul.isMainCategory(categoryOption)) {
      setCategory(categoryOption);

      if (hasSelectedCategorySubCategories()) {
        setSubCategory(getSubCategoriesOf(category).first);
      } else {
        setSubCategory(CategoryOptions.None);
      }
    } else if (CategoryModul.isSubCategory(categoryOption)) {
      setSubCategory(categoryOption);
      setCategory(CategoryModul.getMainCategoryOfSubCategory(categoryOption));
    }
    refreshCategoryName();
    update();
  }

  String getCategoryName(CategoryOptions categoryOption) {
    return CategoryModul.getCategoryName(categoryOption);
  }

  bool isMainCategorySelected(CategoryOptions value) =>
      (CategoryModul.isMainCategory(value) && value == category);

  bool hasSelectedCategorySubCategories() =>
      (CategoryModul.hasCategorySubCategories(category));

  bool isSubCategorySelected(CategoryOptions value) =>
      (CategoryModul.isSubCategory(value) && value == subCategory);

  updatePost() async {
    if (category == CategoryOptions.None) {
      Get.snackbar('Aktualisieren nicht möglich',
          'Wählen Sie bitte eine gültige Kategorie aus');
      return;
    } else if (!formKey.currentState!.validate()) {
      Get.snackbar('Aktualisieren nicht möglich',
          'Füllen Sie bitte die Eingabefelder richtig aus');
      return;
    } else if (oldPost == null) {
      Get.snackbar(
          'Aktualisieren nicht möglich', 'Das ist ein ungültiger Post');
    }

    if (category == CategoryOptions.Event) {
      if (!eventKey.currentState!.validate()) {
        Get.snackbar('Posten nicht möglich',
            'Füllen Sie bitte die Eingabefelder zum Event richtig aus');
        return;
      }
      if (eventTime != null) {
        if (eventTime!.length != 2) {
          Get.snackbar(
              'Posten nicht möglich', 'Geben Sie bitte zwei gültige Daten an');
          return;
        } else if (eventTime![0].isAfter(eventTime![1])) {
          Get.snackbar('Posten nicht möglich',
              'Das erste Datum muss früher sein als das zweite');
          return;
        }
      } else {
        Get.snackbar(
            'Posten nicht möglich', 'Füllen Sie bitte das Datumfeld aus');
        return;
      }
    }

    try {
      /*if ((imageFileOfOldPost != null &&
              imageName.isNotEmpty &&
              imageFileOfOldPost!.name != imageName) ||
          (imageFileOfOldPost != null && image == null)) {
        storageService.deletePostImageFromStorage(imageFileOfOldPost!.name);
      }*/

      final imageUrl = image == null
          ? ''
          : (imageFileOfOldPost != null &&
                      image != null &&
                      imageFileOfOldPost!.file != image) ||
                  (imageFileOfOldPost == null && image != null)
              ? await storageService.uploadPostImageToStorage(imageName, image!)
              : oldPost!.imageUrl;

      final post = Post(
          id: oldPost!.id,
          uid: FirebaseAuth.instance.currentUser!.uid,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          createdAt: oldPost!.createdAt,
          imageUrl: imageUrl,
          category: subCategory != CategoryOptions.None
              ? subCategory.name.toString()
              : category.name.toString(),
          tags: [...tags..sort()],
          likes: 0,
          range: sliderValue);

      postRepository.update(post);
      Get.back();
      clear();
    } on Exception catch (e) {
      print(e);
      Get.snackbar('Aktualisieren Fehlgeschlagen',
          'Der Post konnte nicht aktualisiert werden');
      //Get.snackbar('Error', e.message!);
    }
  }

  @override
  clear({bool alsoCategory = true}) {
    oldPost = null;
    return super.clear(alsoCategory: alsoCategory);
  }

  /*bool isSelected(CategoryOptions value) =>
      (CategoryModul.isMainCategory(value) && value == category) ||
      (CategoryModul.isSubCategory(value) && value == subCategory) ||
      (category == CategoryModul.lending &&
          CategoryModul.subCategoriesOfLending.contains(value)) ||
      (category == CategoryModul.message &&
          CategoryModul.subCategoriesOfMessage.contains(value)) ||
      (category == CategoryModul.event &&
          CategoryModul.subCategoriesOfEvent.contains(value)) ||
      (category == CategoryModul.search &&
          CategoryModul.subCategoriesOfSearch.contains(value));*/
}
