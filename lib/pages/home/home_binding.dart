import 'package:get/get.dart';
import 'package:locoo/models/auth_access.dart';
import 'package:locoo/models/data_access.dart';
import 'package:locoo/pages/auth/auth_controller.dart';
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
  }
}