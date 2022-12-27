class CommentFilter {
  CommentFilterSortBy commentFilterSortBy = CommentFilterSortBy.date;
  bool isOrderDescending = true;

  void swapOrder() {
    isOrderDescending = !isOrderDescending;
  }

  CommentFilter createCopy() {
    final result = CommentFilter();
    result.commentFilterSortBy = commentFilterSortBy;
    result.isOrderDescending = isOrderDescending;
    return result;
  }
}

enum CommentFilterSortBy { date, likes }
