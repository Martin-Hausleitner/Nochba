import 'package:get/get.dart';
import 'package:nochba/logic/auth_access.dart';
import 'package:nochba/logic/data_access.dart';
import 'package:nochba/pages/auth/auth_controller.dart';
import 'package:nochba/pages/new_post/new_post_controller.dart';

// import '../account/account_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    // Get.lazyPut<AccountController>(() => AccountController());
    Get.put(DataAccess());
    Get.put(AuthAccess());
    Get.put(NewPostController());
    Get.put(AuthController());
  }
}
