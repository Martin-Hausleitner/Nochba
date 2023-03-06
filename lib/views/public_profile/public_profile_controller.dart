import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
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
}
