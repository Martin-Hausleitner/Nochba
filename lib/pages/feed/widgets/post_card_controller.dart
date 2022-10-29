import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';

class PostCardController extends GetxController {
  final notificationRepository = Get.find<NotificationRepository>();

  Future<void> sendNotification(String toUserId, String postId) async {
    try {
      return await notificationRepository
          .sendPostRequestNotificationFromCurrentUser(toUserId, postId);
    } on Exception {
      return Future.error(Error);
    }
  }

  final authService = Get.find<AuthService>();

  bool shouldShowWriteToButton(String uid, CategoryOptions category) {
    return uid != authService.uid &&
        (category == CategoryModul.search ||
            CategoryModul.subCategoriesOfSearch.contains(category) ||
            category == CategoryModul.lending ||
            CategoryModul.subCategoriesOfLending.contains(category));
  }
}
