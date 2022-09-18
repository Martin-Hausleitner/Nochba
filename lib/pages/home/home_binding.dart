import 'package:get/get.dart';
import 'package:locoo/logic/auth_access.dart';
import 'package:locoo/logic/data_access.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
import 'package:locoo/pages/chats/chat_controller.dart';
import 'package:locoo/pages/chats/chats_controller.dart';
import 'package:locoo/pages/dashboard/dashboard_controller.dart';
import 'package:locoo/pages/new_post/new_post_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
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