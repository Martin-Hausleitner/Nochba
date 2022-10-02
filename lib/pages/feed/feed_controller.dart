import 'package:get/get.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class FeedController extends GetxController {
  final postRepository = Get.find<PostRepository>();
  final userRepository = Get.find<UserRepository>();

  Stream<List<Post>> getPosts() {
    try {
      return postRepository.getAllPosts(true);
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<User?> getUser(String id) {
    try {
      return userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }
}
