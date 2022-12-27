import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/CommentRepository.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_page.dart';

class ActionBarController extends GetxController {
  final _bookMarkRepository = Get.find<BookMarkRepository>();

  Stream<BookMark?> getBookMarkOfCurrentUser() {
    try {
      return _bookMarkRepository.getBookMarkOfCurrentUser();
    } on Exception {
      return Stream.error(Error());
    }
  }

  Future<void> unsavePost(BookMark bookMark, String postId) async {
    try {
      bookMark.posts.removeWhere((e) => e == postId);
      return await _bookMarkRepository.updateBookMarkOfCurrentUser(bookMark);
    } on Exception {
      return Future.error(Error());
    }
  }

  Future<void> savePost(BookMark bookMark, String postId) async {
    try {
      bookMark.posts.add(postId);
      return await _bookMarkRepository.updateBookMarkOfCurrentUser(bookMark);
    } on Exception {
      return Future.error(Error());
    }
  }

  final commentRepository = Get.find<CommentRepository>();

  Future<int> getCommentCountOfPost(String postId) {
    try {
      return commentRepository.getCommentCountOfPost(postId);
    } on Exception {
      return Future.error(Error);
    }
  }

  final _authService = Get.find<AuthService>();

  bool isThisTheCurrentUser(String uid) {
    return uid == _authService.uid;
  }

  pushEditPostView(String postId) {
    Get.to(() => EditPostPage(
          postId: postId,
        ));
  }

  final _postRepository = Get.find<PostRepository>();

  Future<int?> getLikesOfPost(String postId) async {
    try {
      return await _postRepository.getLikesOfPost(postId);
    } on Exception {
      return Future.error(Error);
    }
  }

  deletePost(String postId) {
    try {
      _postRepository.delete(postId);
      Get.snackbar(
          'Post wurde gelöscht', 'Dein Post wurde erfolgreich gelöscht');
    } on Exception {
      Get.snackbar(
          'Löschen fehlgeschlagen', 'Der Post konnte nicht gelöscht werden');
    }
  }
}
