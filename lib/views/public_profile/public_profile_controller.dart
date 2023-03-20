import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/Report.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/repositories/ReportRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/pages/private_profile/views/edit_profile_view.dart';

class PublicProfileController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _userRepository = Get.find<UserRepository>();
  final _userPublicInfoRepository = Get.find<UserPublicInfoRepository>();
  final _notificationRepository = Get.find<NotificationRepository>();
  final _postRepository = Get.find<PostRepository>();

  Future<User?> getUser(String id) {
    try {
      return _userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<String> getDistanceToUser(String userId) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'getDistanceToOtherUser',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final result = await callable.call(<String, dynamic>{
        'userId': userId,
      });

      return result.data;
    } catch (e) {
      return '---';
    }
  }

  Stream<List<Post>> getPostsOfUser(String uid) {
    try {
      return _postRepository.getPostsOfUserAsStream(uid);
    } catch (e) {
      return Stream.error(Error);
    }
  }

  Future<UserPublicInfo?> getPublicInfoOfUser(String id) {
    try {
      return _userPublicInfoRepository.getPublicInfoOfUser(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> sendNotification(String toUserId) async {
    try {
      return await _notificationRepository
          .sendChatRequestNotificationFromCurrentUser(toUserId);
    } on Exception {
      return Future.error(Error);
    }
  }

  bool shouldShowWriteToButton(String uid) => uid != _authService.uid;
  bool shouldShowEditProfileButton(String uid) => uid == _authService.uid;

  pushEditProfileView() {
    Get.to(() => const EditProfileView());
  }

  final _reportRepository = Get.find<ReportRepository>();

  List<String> get reasonsForReport => Report.reasonsForReport;

  String? selectedReasonForReport;

  final reportKey = GlobalKey<FormState>();
  TextEditingController reportTextController = TextEditingController();

  void selectReasonForReport(String? reason) {
    selectedReasonForReport = reason;
    update(['ReportUserDropDown']);
  }

  Future onPressReportSend(String userId) async {
    try {
      if (selectedReasonForReport == null) {
        Get.snackbar('Grund nicht ausgewählt',
            'Bitte wählen Sie einen Grund für die Meldung aus.');
        return;
      }

      if (!reportKey.currentState!.validate()) {
        return;
      }

      var report = Report(
          fromUser: _authService.uid,
          reportedId: userId,
          type: ReportType.user,
          reason: selectedReasonForReport!,
          text: reportTextController.text,
          createdAt: Timestamp.now());

      await _reportRepository.insert(report);

      Get.back();

      Get.snackbar('Meldung abgeschickt', 'Der User wurde gemeldet.');
    } catch (e) {
      Get.snackbar(
          'Melden fehlgeschlagen', 'Das Melden des Users ist fehlgeschlagen.');
    }
  }
}
