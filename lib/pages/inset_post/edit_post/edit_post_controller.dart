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

  final storageService = Get.find<StorageService>();

  final Rx<CategoryOptions> _category = CategoryOptions.None.obs;
  final Rx<CategoryOptions> _subCategory = CategoryOptions.None.obs;

  CategoryOptions get category => _category.value;
  CategoryOptions get subCategory => _subCategory.value;

  final Rx<String> _categoryName = ''.obs;
  String get categoryName => _categoryName.value;

  void refreshCategoryName() =>
      _categoryName.value = subCategory != CategoryOptions.None
          ? "${category.name.toString()} - ${subCategory.name.toString()}"
          : category.name.toString();

  Future<bool> initializePage(Post post) async {
    clear();

    oldPost = post;

    titleController.text = post.title;
    descriptionController.text = post.description;

    CategoryOptions tmp = CategoryModul.getCategoryOptionByName(post.category);
    if (CategoryModul.isMainCategory(tmp)) {
      _category.value = tmp;
    } else if (CategoryModul.isSubCategory(tmp)) {
      _subCategory.value = tmp;
      _category.value = CategoryModul.getMainCategoryOfSubCategory(tmp);
    }
    refreshCategoryName();
    addTags(post.tags);

    ImageFile? imageFile =
        await storageService.downloadPostImageFromStorage(post.imageUrl);
    if (imageFile != null) {
      setImageFile(imageFile);
    }

    return true;
  }

  List<CategoryOptions> get mainCategories => CategoryModul.mainCategories;
  List<CategoryOptions> getSubCategoriesOf(CategoryOptions categoryOptions) =>
      CategoryModul.getSubCategoriesOfMainCategory(categoryOptions);

  selectCategory(CategoryOptions categoryOption) {
    if (CategoryModul.isMainCategory(categoryOption) &&
        CategoryModul.getSubCategoriesOfMainCategory(categoryOption).isEmpty) {
      _category.value = categoryOption;
      _subCategory.value = CategoryOptions.None;
    } else if (CategoryModul.isSubCategory(categoryOption)) {
      _subCategory.value = categoryOption;
      _category.value =
          CategoryModul.getMainCategoryOfSubCategory(categoryOption);
    }
    refreshCategoryName();
  }

  bool isMainCategorySelected(CategoryOptions value) =>
      (CategoryModul.isMainCategory(value) && value == category);

  bool isSubCategorySelected(CategoryOptions value) =>
      (CategoryModul.isSubCategory(value) && value == subCategory);

  final postRepository = Get.find<PostRepository>();

  updatePost() async {
    //final isValid = formKey.currentState!.validate();
    if (/*!isValid ||*/ category == CategoryOptions.None || oldPost == null)
      return;

    try {
      final imageUrl = image == null
          ? ''
          : await storageService.uploadPostImageToStorage(imageName, image!);
      final post = Post(
        id: oldPost!.id,
        user: FirebaseAuth.instance.currentUser!.uid,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdAt: oldPost!.createdAt,
        imageUrl: imageUrl,
        category: subCategory != CategoryOptions.None
            ? subCategory.name.toString()
            : category.name.toString(),
        tags: [...tags..sort()],
        liked: [],
      );

      postRepository.update(post);
      clear();
      Get.back();
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar('Aktualisieren Fehlgeschlagen',
          'Der Post konnte nicht aktualisiert werden');
      //Get.snackbar('Error', e.message!);
    }
  }

  @override
  clear() {
    oldPost = null;
    _category.value = CategoryOptions.None;
    _subCategory.value = CategoryOptions.None;
    _categoryName.value = '';
    return super.clear();
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
