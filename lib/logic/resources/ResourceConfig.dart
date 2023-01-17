import 'package:meta/meta.dart';

@immutable
class ResourceConfig {
  const ResourceConfig();

  /// Property to set rooms collection name.
  final String roomsCollectionName = 'rooms';

  /// Property to set users collection name.
  final String usersCollectionName = 'users';

  /// Property to set userPublicInfo collection name.
  final String userPublicInfoCollectionName = 'public';

  /// Property to set userPrivateInfo collection name.
  final String userPrivateInfoCollectionName = 'private';

  /// Property to set userInternInfo collection name.
  final String userInternInfoCollectionName = 'intern';

  /// Property to set bookmarks collection name.
  final String bookMarksCollectionName = 'record';

  /// Property to set likedPosts collection name.
  final String likedPostsCollectionName = 'likedPosts';

  /// Property to set likedComments collection name.
  final String likedCommentsCollectionName = 'likedComments';

  /// Property to set tokens collection name.
  final String tokenCollectionName = 'tokens';

  /// Property to set posts collection name.
  final String postsCollectionName = 'posts';

  /// Property to set notifications collection name.
  final String notificationsCollectionName = 'notifications';

  /// Property to set comments comments name.
  final String commentsCollectionName = 'comments';
}
