import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/CommentFilter.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class CommentRepository extends GenericRepository<Comment> {
  CommentRepository(super.resourceContext);

  Stream<List<Comment>> getCommentsOfPost(
      String postId, CommentFilter commentFilter) {
    final orderFieldDescending = MapEntry(
        commentFilter.commentFilterSortBy == CommentFilterSortBy.date
            ? 'createdAt'
            : commentFilter.commentFilterSortBy == CommentFilterSortBy.likes
                ? 'likes'
                : '',
        commentFilter.isOrderDescending);

    return queryAsStream(orderFieldDescending, nexus: [postId]);
  }

  Future<int> getCommentCountOfPost(String postId) {
    return getSize(nexus: [postId]);
  }

  Future<int?> getLikesOfPost(String id, String postId) async {
    final comment = await get(id, nexus: [postId]);
    return comment?.likes;
  }
}
