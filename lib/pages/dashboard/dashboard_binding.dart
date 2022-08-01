import 'package:get/get.dart';


// import '../account/account_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Get.lazyPut<AccountController>(() => AccountController());
  }
}
