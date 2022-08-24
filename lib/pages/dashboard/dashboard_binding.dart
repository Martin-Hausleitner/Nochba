import 'package:get/get.dart';
import 'package:locoo/models/data_access.dart';
import 'package:locoo/pages/new_post/new_post_controller.dart';


// import '../account/account_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Get.lazyPut<AccountController>(() => AccountController());
    Get.put(DataAccess());
    Get.put(NewPostController());
  }
}
