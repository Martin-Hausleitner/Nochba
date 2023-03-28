import 'package:get/get.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    if (index == 0) {
      update(['FeedPage']);
    }
    tabIndex = index;
    update();
  }

  final _notificationRepository = Get.find<NotificationRepository>();

  Stream<bool?> hasUnseenNotifications() {
    try {
      return _notificationRepository.hasCurrentUserAnyUnseenNotifications();
    } on Exception {
      return Stream.error(Error);
    }
  }
}
