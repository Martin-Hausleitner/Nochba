import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    if (index == 0) {
      update(['FeedPage']);
    }
    tabIndex = index;
    update();
  }
}
