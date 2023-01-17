import 'package:nochba/logic/models/category.dart';

class PostFilter {
  double radius = 100;
  List<CategoryOptions> categories = <CategoryOptions>[];
  PostFilterSortBy postFilterSortBy = PostFilterSortBy.date;
  bool isOrderDescending = true;

  void addCategory(CategoryOptions categoryOption) {
    categories.add(categoryOption);
  }

  void removeCategory(CategoryOptions categoryOption) {
    categories.remove(categoryOption);
  }

  void swapOrder() {
    isOrderDescending = !isOrderDescending;
  }

  PostFilter createCopy() {
    final result = PostFilter();
    result.categories = categories;
    result.postFilterSortBy = postFilterSortBy;
    result.isOrderDescending = isOrderDescending;
    return result;
  }
}

enum PostFilterSortBy { date, likes }
