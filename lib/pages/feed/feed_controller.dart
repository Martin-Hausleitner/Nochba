import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/PostFilter.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class FeedController extends GetxController {
  final postRepository = Get.find<PostRepository>();
  final userRepository = Get.find<UserRepository>();

  Stream<List<Post>> getPosts() {
    try {
      //return postRepository.getAllPosts(true);
      return postRepository.queryPosts(postFilter.value);
    } on Exception catch (e) {
      return Stream.error(e);
    }
  }

  final searchInputController = TextEditingController();
  void onSearchInputChanged(String value) {
    update();
  }

  Future<List<Post>> searchPosts() async {
    try {
      return postRepository.searchPosts(
          searchInputController.text, postFilter.value);
    } on Exception catch (e) {
      print(e);
      return Future.error(Error);
    }
  }

  Future<User?> getUser(String id) {
    try {
      return userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Rx<PostFilter> postFilter = PostFilter().obs;
  Rx<PostFilter> extendedPostFilter = PostFilter().obs;

  void onSliderValueChanged(double newValue) {
    extendedPostFilter.value.changeRange(newValue);
    update(['PostFilterRangeSlider']);
  }

  double get sliderValue => extendedPostFilter.value.range;

  void updateExtendedPostFilter() {
    extendedPostFilter.value = postFilter.value.createCopy();
    update();

    // Get.snackbar(extendedPostFilter.value.categories.length.toString(),
    //     extendedPostFilter.value.categories.toString());
  }

  void takeOverExtendedPostFilter() {
    postFilter.value = extendedPostFilter.value.createCopy();
    update();
  }

  // bool showSubCatogoriesChipsOfMainCategories(CategoryOptions categoryOption) =>
  //     CategoryModul.isMainCategory(categoryOption) &&
  //     (postFilter.value.categories.contains(categoryOption) ||
  //         postFilter.value.categories.any((element) =>
  //             CategoryModul.getSubCategoriesOfMainCategory(categoryOption)
  //                 .contains(element)));

  bool isCategoryChipSelected(CategoryOptions categoryOption) =>
      isCategorySelected(categoryOption, postFilter);

  bool isCategoryChipAsMainCategoryIncluded(CategoryOptions categoryOption) =>
      isChipAsMainCategoryIncluded(categoryOption, postFilter);

  void selectCategoryChip(CategoryOptions categoryOption) =>
      selectCategory(categoryOption, postFilter);

  bool isFilterChipSelected(CategoryOptions categoryOption) =>
      isCategorySelected(categoryOption, extendedPostFilter);

  bool isFilterChipAsMainCategoryIncluded(CategoryOptions categoryOption) =>
      isChipAsMainCategoryIncluded(categoryOption, extendedPostFilter);

  void selectFilterChip(CategoryOptions categoryOption) =>
      selectCategory(categoryOption, extendedPostFilter);

  bool isCategorySelected(
          CategoryOptions categoryOption, Rx<PostFilter> filter) =>
      (categoryOption == CategoryOptions.None &&
          filter.value.categories.isEmpty) ||
      filter.value.categories.contains(categoryOption);

  bool isChipAsMainCategoryIncluded(
          CategoryOptions categoryOption, Rx<PostFilter> filter) =>
      CategoryModul.isMainCategory(categoryOption) &&
      filter.value.categories.any((element) =>
          CategoryModul.getSubCategoriesOfMainCategory(categoryOption)
              .contains(element));

  void selectCategory(CategoryOptions categoryOption, Rx<PostFilter> filter) {
    if (categoryOption == CategoryOptions.None) {
      filter.value.categories.clear();
    } else if (filter.value.categories.contains(categoryOption)) {
      filter.value.removeCategory(categoryOption);
    } else {
      if (CategoryModul.isMainCategory(categoryOption)) {
        filter.value.categories.removeWhere((element) =>
            CategoryModul.getSubCategoriesOfMainCategory(categoryOption)
                .contains(element));
      } else if (CategoryModul.isSubCategory(categoryOption)) {
        filter.value.categories.removeWhere((element) =>
            CategoryModul.getMainCategoryOfSubCategory(categoryOption) ==
            element);
      }

      filter.value.addCategory(categoryOption);

      if (CategoryModul.mainCategories
          .every((element) => filter.value.categories.contains(element))) {
        filter.value.categories.clear();
      }
    }
    update();
  }

  bool isPostFilterSortBySelected(PostFilterSortBy postFilterSortBy) =>
      extendedPostFilter.value.postFilterSortBy == postFilterSortBy;
  void selectPostFilterSortBy(PostFilterSortBy postFilterSortBy) {
    extendedPostFilter.value.postFilterSortBy = postFilterSortBy;
    update();
  }

  bool isDescending() => extendedPostFilter.value.isOrderDescending;
  bool isAscending() => !extendedPostFilter.value.isOrderDescending;
  void swapOrder() {
    extendedPostFilter.value.swapOrder();
    update();
  }
}
