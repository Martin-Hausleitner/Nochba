import 'package:get/get.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';

class NotificationsController extends GetxController {
  final notificationRepository = Get.find<NotificationRepository>();

  Stream<List<Notification>> getNotificationsOfCurrentUser() {
    try {
      return notificationRepository.getNotifiactionsOfCurrentUser();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<void> deleteNotification(notificationId) {
    try {
      return notificationRepository.delete(notificationId);
    } on Exception {
      return Future.error(Error);
    }
  }
}
