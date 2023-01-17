import 'package:nochba/logic/models/LikedComment.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class LikedCommentRepository extends GenericRepository<LikedComment> {
  LikedCommentRepository(super.resourceContext);

  Stream<List<LikedComment>> getLikedCommentsOfCurrentUser() {
    return getAll(nexus: [resourceContext.uid]).map((likedComments) =>
        likedComments
            .map((likedComment) =>
                LikedComment(id: likedComment.id, post: likedComment.post))
            .toList());
  }

  Future<void> insertLikedComment(String commentId, String postId) async {
    await insert(LikedComment(id: commentId, post: postId),
        nexus: [resourceContext.uid]);
  }

  Future<void> deleteLikedComment(String commentId) async {
    await delete(commentId, nexus: [resourceContext.uid]);
  }
}
