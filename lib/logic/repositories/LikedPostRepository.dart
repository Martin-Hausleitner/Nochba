import 'package:nochba/logic/models/LikedPost.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class LikedPostRepository extends GenericRepository<LikedPost> {
  LikedPostRepository(super.resourceContext);

  Stream<List<String>> getLikedPostsOfCurrentUser() {
    return getAll(nexus: [resourceContext.uid]).map(
        (likedPosts) => likedPosts.map((likedPost) => likedPost.id).toList());
  }

  Future<void> insertLikedPost(String postId) async {
    await insert(LikedPost(id: postId), nexus: [resourceContext.uid]);
  }

  Future<void> deleteLikedPost(String postId) async {
    await delete(postId, nexus: [resourceContext.uid]);
  }
}
