import 'package:get/get.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class PrivateProfileController extends GetxController {
  var counter = 0.obs;

  void increaseCounter() {
    counter.value += 1;
  }

  final userRepository = Get.find<UserRepository>();

  Future<User?> getCurrentUser() {
    try {
      return userRepository.getCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }
}
