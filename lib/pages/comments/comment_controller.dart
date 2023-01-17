import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/CommentFilter.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/CommentRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class CommentController extends GetxController {
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _commentRepository = Get.find<CommentRepository>();
  final _userRepository = Get.find<UserRepository>();
  final _authService = Get.find<AuthService>();

  CommentFilter commentFilter = CommentFilter();

  Stream<List<Comment>> getComments(String postId) {
    try {
      return _commentRepository.getCommentsOfPost(postId, commentFilter);
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<User?> getUser(String id) {
    try {
      return _userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future addComment(String postId) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    final comment = Comment(
        uid: _authService.uid,
        text: textController.text.trim(),
        createdAt: Timestamp.now(),
        post: postId);

    try {
      await _commentRepository.insert(comment, nexus: [postId]);

      textController.clear();
    } on Exception {
      Get.snackbar('Error', 'message');
      return Future.error(Error);
    }
  }

  bool isCommentFilterSortBySelected(CommentFilterSortBy commentFilterSortBy) =>
      commentFilter.commentFilterSortBy == commentFilterSortBy;
  void selectCommentFilterSortBy(CommentFilterSortBy commentFilterSortBy) {
    commentFilter.commentFilterSortBy = commentFilterSortBy;
    update();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
