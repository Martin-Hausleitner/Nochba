import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/pages/private_profile/views/edit_profile_view.dart';

class PublicProfileController extends GetxController {
  var counter = 0.obs;

  void increaseCounter() {
    counter.value += 1;
  }

  final authService = Get.find<AuthService>();
  final userRepository = Get.find<UserRepository>();
  final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();
  final notificationRepository = Get.find<NotificationRepository>();

  Future<User?> getUser(String id) {
    try {
      return userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<UserPublicInfo?> getPublicInfoOfUser(String id) {
    try {
      return userPublicInfoRepository.getPublicInfoOfUser(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> sendNotification(String toUserId) async {
    try {
      return await notificationRepository
          .sendChatRequestNotificationFromCurrentUser(toUserId);
    } on Exception {
      return Future.error(Error);
    }
  }

  bool shouldShowWriteToButton(String uid) => uid != authService.uid;
  bool shouldShowEditProfileButton(String uid) => uid == authService.uid;

  pushEditProfileView() {
    Get.to(() => const EditProfileView());
  }
}
