import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/CommentRepository.dart';
import 'package:nochba/logic/repositories/LikedCommentRepository.dart';
import 'package:nochba/logic/repositories/LikedPostRepository.dart';
// import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/repositories/TokenRepository.dart';
import 'package:nochba/logic/repositories/UserInternInfoAddressRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoAddressRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/logic/resources/ResourceContext.dart';
import 'package:nochba/logic/auth_access.dart';
import 'package:nochba/logic/data_access.dart';
import 'package:nochba/logic/storage/StorageService.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:nochba/pages/auth/login_controller.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/chats/chat_controller.dart';
import 'package:nochba/pages/chats/chats_controller.dart';
import 'package:nochba/pages/comments/comment_controller.dart';
import 'package:nochba/pages/comments/widgets/action_bar_controller.dart'
    as comment;
import 'package:nochba/pages/dashboard/dashboard_controller.dart';
import 'package:nochba/pages/feed/feed_controller.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar_controller.dart'
    as post;
import 'package:nochba/pages/feed/widgets/post_card_controller.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:nochba/pages/inset_post/new_post/new_post_controller.dart';
import 'package:nochba/pages/notifications/notifications_controller.dart';
import 'package:nochba/pages/private_profile/private_profile_controller.dart';
import 'package:nochba/pages/private_profile/views/edit_profile_controller.dart';
import 'package:nochba/views/public_profile/public_profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(ResourceContext()));
    Get.put(StorageService());
    Get.put(SignUpController());
    Get.put(LoginController());

    Get.put(BookMarkRepository(ResourceContext()));
    Get.put(UserPrivateInfoNameRepository(ResourceContext()));
    Get.put(UserPrivateInfoSettingsRepository(ResourceContext()));
    Get.put(UserPrivateInfoAddressRepository(ResourceContext()));
    Get.put(UserInternInfoAddressRepository(ResourceContext()));
    Get.put(LikedPostRepository(ResourceContext()));
    Get.put(CommentRepository(ResourceContext()));
    Get.put(LikedCommentRepository(ResourceContext()));

    Get.put(PostRepository(ResourceContext()));
    Get.put(UserRepository(ResourceContext()));
    Get.put(UserPublicInfoRepository(ResourceContext()));
    Get.put(TokenRepository(ResourceContext()));
    Get.put(NotificationRepository(ResourceContext()));

    Get.put(CommentController());
    Get.put(comment.CommentActionBarController());
    Get.put(post.ActionBarController());
    Get.put(PostCardController());
    Get.put(PublicProfileController());
    Get.put(FeedController());
    Get.put(NotificationsController());
    Get.put(PrivateProfileController());
    Get.put(EditProfileController());

    Get.put<DashboardController>(DashboardController());
    // Get.lazyPut<AccountController>(() => AccountController());
    Get.put(DataAccess());
    Get.put(AuthAccess());
    Get.put(NewPostController());
    Get.put(EditPostController());
    Get.put(AuthController());
    Get.put(ChatsController());
    Get.put(ChatController());
  }
}
