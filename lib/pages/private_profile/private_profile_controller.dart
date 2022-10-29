import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/views/public_profile/public_profile_view.dart';

class PrivateProfileController extends GetxController {
  var counter = 0.obs;

  void increaseCounter() {
    counter.value += 1;
  }

  final userRepository = Get.find<UserRepository>();
  final postRepository = Get.find<PostRepository>();
  final authService = Get.find<AuthService>();

  pushPublicProfileView() {
    Get.to(() => PublicProfileView(userId: authService.uid));
  }

  Future<User?> getCurrentUser() {
    try {
      return userRepository.getCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<User?> getUser(String id) {
    try {
      return userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<List<Post>> getPostsOfCurrentUser() async {
    try {
      return await postRepository.getPostsOfCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<List<Post>> getMarkedPostsOfCurrentUser() async {
    try {
      return await postRepository.getMarkedPostsOfCurrentUser();
    } on Exception {
      return Future.error(Error);
    }
  }
}
