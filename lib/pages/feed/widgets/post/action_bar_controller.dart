import 'package:get/get.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';

class ActionBarController extends GetxController {
  final bookMarkRepository = Get.find<BookMarkRepository>();

  Stream<BookMark?> getBookMarkOfCurrentUser() {
    try {
      return bookMarkRepository.getBookMarkOfCurrentUser();
    } on Exception {
      return Stream.error(Error());
    }
  }

  Future<void> unsavePost(BookMark bookMark, String postId) async {
    try {
      bookMark.posts.removeWhere((e) => e == postId);
      return await bookMarkRepository.updateBookMarkOfCurrentUser(bookMark);
    } on Exception {
      return Future.error(Error());
    }
  }

  Future<void> savePost(BookMark bookMark, String postId) async {
    try {
      bookMark.posts.add(postId);
      return await bookMarkRepository.updateBookMarkOfCurrentUser(bookMark);
    } on Exception {
      return Future.error(Error());
    }
  }
}
