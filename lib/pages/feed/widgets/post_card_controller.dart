import 'package:get/get.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';

class PostCardController extends GetxController {
  final notificationRepository = Get.find<NotificationRepository>();

  Future<void> sendNotification(String toUserId, String postId) async {
    try {
      return await notificationRepository.insertNotificationFromCurrentUser(
          toUserId, postId);
    } on Exception {
      return Future.error(Error);
    }
  }
}
