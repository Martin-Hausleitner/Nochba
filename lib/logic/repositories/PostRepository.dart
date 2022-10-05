import 'package:get/get.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/models/post.dart';

class PostRepository extends GenericRepository<Post> {
  PostRepository(super.resourceContext);

  Stream<List<Post>> getAllPosts(bool orderFieldDescending) {
    return super.getAll(
        orderFieldDescending: MapEntry('createdAt', orderFieldDescending));
  }

  Future<String?> getPostTitle(String id) async {
    final post = await get(id);
    return post?.title;
  }

  Future<List<Post>> getPostsOfCurrentUser() async {
    return await query(const MapEntry('createdAt', true),
        whereIsEqualTo: {'user': resourceContext.uid});
  }

  Future<List<Post>> getMarkedPostsOfCurrentUser() async {
    final bookMarkRepo = loadResource<BookMark>();
    final uid = resourceContext.uid;
    final bookMark = await bookMarkRepo.get(uid, nexus: [uid]);
    if (bookMark != null && bookMark.posts.isNotEmpty) {
      final postIds = bookMark.posts;
      final posts = await query(const MapEntry('createdAt', true),
          whereIn: MapEntry('id', postIds));

      return posts.isNotEmpty ? posts : List.empty();
    }
    return List.empty();
  }
}
