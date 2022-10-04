import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';
// import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/logic/resources/ResourceContext.dart';
import 'package:nochba/logic/auth_access.dart';
import 'package:nochba/logic/data_access.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:nochba/pages/auth/login_controller.dart';
import 'package:nochba/pages/auth/register/sign_up_controller.dart';
import 'package:nochba/pages/chats/chat_controller.dart';
import 'package:nochba/pages/chats/chats_controller.dart';
import 'package:nochba/pages/dashboard/dashboard_controller.dart';
import 'package:nochba/pages/feed/feed_controller.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar_controller.dart';
import 'package:nochba/pages/new_post/new_post_controller.dart';
import 'package:nochba/pages/notifications/notifications_controller.dart';
import 'package:nochba/pages/private_profile/private_profile_controller.dart';
import 'package:nochba/pages/private_profile/views/edit_profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(ResourceContext()));
    Get.put(SignUpController());
    Get.put(LoginController());

    Get.put(BookMarkRepository(ResourceContext()));

    Get.put(PostRepository(ResourceContext()));
    Get.put(UserRepository(ResourceContext()));
    Get.put(UserPublicInfoRepository(ResourceContext()));
    Get.put(NotificationRepository(ResourceContext()));
    Get.put(ActionBarController());
    Get.put(FeedController());
    Get.put(NotificationsController());
    Get.put(PrivateProfileController());
    Get.put(EditProfileController());

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
