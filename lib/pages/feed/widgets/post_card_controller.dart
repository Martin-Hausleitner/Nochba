import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
// import 'package:simplytranslate/simplytranslate.dart';

class PostCardController extends GetxController {
  final notificationRepository = Get.find<NotificationRepository>();

  Future<void> sendNotification(String toUserId, String postId) async {
    try {
      return await notificationRepository
          .sendPostRequestNotificationFromCurrentUser(toUserId, postId);
    } on Exception {
      Get.snackbar('Fehlgeschlagen', 'Das Anschreiben ist fehlgeschlagen');
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

  Future<String> getDistanceToUser(String postId) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'getDistanceFromTwoUsers',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final result = await callable.call(<String, dynamic>{
        'postId': postId,
      });

      return result.data;
    } catch (e) {
      // Get.snackbar('Error', e.toString());
      return '---';
    }
  }

  
  
}
