import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';

class ManageAccountController extends GetxController {
  final _authService = Get.find<AuthService>();

  Future deleteAccount() async {
    await _authService.deleteAccountAndUserData();

    await _authService.signOut();
  }
}
