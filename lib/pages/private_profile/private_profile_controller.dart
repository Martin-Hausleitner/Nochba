import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/views/public_profile/public_profile_view.dart';

class PrivateProfileController extends GetxController {
  var counter = 0.obs;

  void increaseCounter() {
    counter.value += 1;
  }

  final _userRepository = Get.find<UserRepository>();
  final _userPrivateInfoNameRepository =
      Get.find<UserPrivateInfoNameRepository>();
  final _postRepository = Get.find<PostRepository>();
  final _authService = Get.find<AuthService>();

  pushPublicProfileView() {
    Get.to(() => PublicProfileView(userId: _authService.uid));
  }

  Future<User?> getCurrentUser() {
    try {
      return _userRepository.getCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<UserPrivateInfoName?> getCurrentUserName() {
    try {
      return _userPrivateInfoNameRepository.getCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<User?> getUser(String id) {
    try {
      return _userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<List<Post>> getPostsOfCurrentUser() async {
    try {
      return await _postRepository.getPostsOfCurrentUser();
    } on Exception catch (e) {
      print('Error: $e');
      return Future.error('Die Posts können derzeit nicht geladen werden');
    }
  }

  Future<List<Post>> getMarkedPostsOfCurrentUser() async {
    try {
      return await _postRepository.getMarkedPostsOfCurrentUser();
    } on Exception catch (e) {
      print('Error: $e');
      return Future.error('Die Posts können derzeit nicht geladen werden');
    }
  }
}
