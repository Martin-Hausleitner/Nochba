import 'package:get/get.dart';
import 'package:locoo/logic/repositories/BookMarkRepository.dart';
// import 'package:locoo/logic/repositories/BookMarkRepository.dart';
import 'package:locoo/logic/repositories/NotificationRepository.dart';
import 'package:locoo/logic/repositories/PostRepository.dart';
import 'package:locoo/logic/repositories/UserRepository.dart';
import 'package:locoo/logic/resources/ResourceContext.dart';
import 'package:locoo/logic/auth_access.dart';
import 'package:locoo/logic/data_access.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
import 'package:locoo/pages/chats/chat_controller.dart';
import 'package:locoo/pages/chats/chats_controller.dart';
import 'package:locoo/pages/dashboard/dashboard_controller.dart';
import 'package:locoo/pages/feed/feed_controller.dart';
import 'package:locoo/pages/feed/widgets/post/action_bar_controller.dart';
import 'package:locoo/pages/new_post/new_post_controller.dart';
import 'package:locoo/pages/notifications/notifications_controller.dart';
import 'package:locoo/pages/private_profile/private_profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BookMarkRepository(ResourceContext()));

    Get.put(PostRepository(ResourceContext()));
    Get.put(UserRepository(ResourceContext()));
    Get.put(NotificationRepository(ResourceContext()));
    Get.put(ActionBarController());
    Get.put(FeedController());
    Get.put(NotificationsController());
    Get.put(PrivateProfileController());

    Get.put<DashboardController>(DashboardController());
    // Get.lazyPut<AccountController>(() => AccountController());
    Get.put(DataAccess());
    Get.put(AuthAccess());
    Get.put(NewPostController());
    Get.put(AuthController());
    Get.put(ChatsController());
    Get.put(ChatController());
  }
}
