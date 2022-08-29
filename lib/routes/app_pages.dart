import 'package:get/get.dart';
import 'package:locoo/pages/home/home_binding.dart';
import 'package:locoo/pages/home/home_page.dart';

import '../pages/dashboard/dashboard_binding.dart';
import '../pages/dashboard/dashboard_page.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.DASHBOARD,
    //   page: () => DashboardPage(),
    //   binding: DashboardBinding(),
    // ),
  ];
}
