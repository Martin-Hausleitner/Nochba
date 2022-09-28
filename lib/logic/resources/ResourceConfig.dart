import 'package:meta/meta.dart';

@immutable
class ResourceConfig {
  const ResourceConfig();

  /// Property to set rooms collection name.
  final String roomsCollectionName = 'rooms';

  /// Property to set users collection name.
  final String usersCollectionName = 'users';

  /// Property to set posts collection name.
  final String postsCollectionName = 'posts';

  /// Property to set bookmarks collection name.
  final String bookMarksCollectionName = 'bookmark';

  /// Property to set notifications collection name.
  final String notificationsCollectionName = 'notifications';

  /// Property to set comments comments name.
  final String commentsCollectionName = 'comments';
}
