import 'package:nochba/logic/models/category.dart';

class PostFilter {
  double range = 400.0;
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

  void changeRange(double newRange) {
    range = newRange;
  }

  PostFilter createCopy() {
    final result = PostFilter();
    result.categories.addAll(categories);
    result.postFilterSortBy = postFilterSortBy;
    result.isOrderDescending = isOrderDescending;
    return result;
  }
}

enum PostFilterSortBy { date, likes }
