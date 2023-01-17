import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/LikedComment.dart';
import 'package:nochba/logic/repositories/CommentRepository.dart';
import 'package:nochba/logic/repositories/LikedCommentRepository.dart';

class CommentActionBarController extends GetxController {
  final _likedCommentRepository = Get.find<LikedCommentRepository>();
  final _commentRepository = Get.find<CommentRepository>();
  final _authService = Get.find<AuthService>();

  Future<int?> getLikesOfComment(String postId, String commentId) async {
    try {
      return await _commentRepository.getLikesOfPost(commentId, postId);
    } on Exception {
      return Future.error(Error);
    }
  }

  Stream<List<LikedComment>> getLikedCommentsOfCurrentUser() {
    try {
      return _likedCommentRepository.getLikedCommentsOfCurrentUser();
    } on Exception {
      return Stream.error(Error());
    }
  }

  Future<void> likeComment(String commentId, String postId) async {
    try {
      return await _likedCommentRepository.insertLikedComment(
          commentId, postId);
    } on Exception {
      Get.snackbar('Liken fehlgeschlagen', 'Beim Liken ist was schiefgelaufen');
    }
  }

  Future<void> unlikeComment(String commentId) async {
    try {
      return await _likedCommentRepository.deleteLikedComment(commentId);
    } catch (e) {
      Get.snackbar('Like zurücknehmen fehlgeschlagen',
          'Beim Zurücknehmen von deinem Like ist was schiefgelaufen');
    }
  }

  bool isThisTheCurrentUser(String uid) {
    return uid == _authService.uid;
  }

  final updateTextController = TextEditingController();
  TextEditingController getTextController(String? text) {
    updateTextController.text = text ?? '';
    return updateTextController;
  }

  Future<void> updateTextOfComment(String postId, String commentId) async {
    try {
      await _commentRepository.updateFields(
          commentId, {'text': updateTextController.text.trim()},
          nexus: [postId]);
      updateTextController.clear();
    } on Exception {
      Get.snackbar('Bearbeiten fehlgeschlagen',
          'Der Kommentar konnte nicht bearbeitet werden');
    }
  }

  Future deleteComment(String postId, String commentId) async {
    try {
      await _commentRepository.delete(commentId, nexus: [postId]);
      Get.snackbar('Kommentar wurde gelöscht',
          'Dein Kommentar wurde erfolgreich gelöscht');
    } on Exception {
      Get.snackbar('Löschen fehlgeschlagen',
          'Der Kommentar konnte nicht gelöscht werden');
    }
  }

  @override
  void dispose() {
    updateTextController.dispose();
    super.dispose();
  }
}
