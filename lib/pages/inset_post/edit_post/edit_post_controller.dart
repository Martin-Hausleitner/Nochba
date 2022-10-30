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

  selectCategory(CategoryOptions categoryOption) {
    if (CategoryModul.isMainCategory(categoryOption) &&
        CategoryModul.getSubCategoriesOfMainCategory(categoryOption).isEmpty) {
      setCategory(categoryOption);
      setSubCategory(CategoryOptions.None);
    } else if (CategoryModul.isSubCategory(categoryOption)) {
      setSubCategory(categoryOption);
      setCategory(CategoryModul.getMainCategoryOfSubCategory(categoryOption));
    }
    refreshCategoryName();
  }

  bool isMainCategorySelected(CategoryOptions value) =>
      (CategoryModul.isMainCategory(value) && value == category);

  bool isSubCategorySelected(CategoryOptions value) =>
      (CategoryModul.isSubCategory(value) && value == subCategory);

  updatePost() async {
    //final isValid = formKey.currentState!.validate();
    if (/*!isValid ||*/ category == CategoryOptions.None || oldPost == null) {
      return;
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
