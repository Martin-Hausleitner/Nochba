import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/repositories/UserPublicInfoRepository.dart';

class PublicProfileController extends GetxController {
  var counter = 0.obs;

  void increaseCounter() {
    counter.value += 1;
  }

  final userPublicInfoRepository = Get.find<UserPublicInfoRepository>();

  Future<UserPublicInfo?> getPublicInfoOfUser(String id) {
    try {
      return userPublicInfoRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }
}
