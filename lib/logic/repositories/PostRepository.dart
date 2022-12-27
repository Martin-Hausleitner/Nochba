import 'package:get/get.dart';
import 'package:nochba/logic/models/PostFilter.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/storage/StorageService.dart';

class PostRepository extends GenericRepository<Post> {
  PostRepository(super.resourceContext);

  final _storageService = Get.find<StorageService>();

  @override
  Future beforeAction(AccessMode accessMode, {Post? model, String? id}) async {
    if (accessMode == AccessMode.delete && id != null) {
      final postBeforeDelete = await get(id);
      final imageName = await _storageService
          .downloadPostImageNameFromStorage(postBeforeDelete!.imageUrl);
      _storageService.deletePostImageFromStorage(imageName);
    } else if (accessMode == AccessMode.update && model != null) {
      final postBeforeDelete = await get(model.id);

      final oldImage = await _storageService
          .downloadPostImageFromStorage(postBeforeDelete!.imageUrl);
      final newImage =
          await _storageService.downloadPostImageFromStorage(model.imageUrl);

      if ((oldImage != null &&
              newImage != null &&
              oldImage.file != newImage.file &&
              oldImage.name != newImage.name) ||
          (oldImage != null && newImage == null)) {
        _storageService.deletePostImageFromStorage(oldImage.name);
      }
    }
  }

  Stream<List<Post>> getAllPosts(bool orderFieldDescending) {
    return super.getAll(
        orderFieldDescending: MapEntry('createdAt', orderFieldDescending));
  }

  Stream<List<Post>> queryPosts(PostFilter postFilter) {
    final orderFieldDescending = MapEntry(
        postFilter.postFilterSortBy == PostFilterSortBy.date
            ? 'createdAt'
            : postFilter.postFilterSortBy == PostFilterSortBy.likes
                ? 'likes'
                : '',
        postFilter.isOrderDescending);

    return postFilter.categories.isNotEmpty
        ? super.queryAsStream(orderFieldDescending,
            whereIn: MapEntry(
                'category',
                postFilter.categories
                    .fold<List<CategoryOptions>>(
                        [],
                        (previousValue, element) => CategoryModul
                                    .isMainCategory(element) &&
                                CategoryModul.getSubCategoriesOfMainCategory(
                                        element)
                                    .isNotEmpty
                            ? [
                                ...previousValue,
                                ...CategoryModul.getSubCategoriesOfMainCategory(
                                    element)
                              ]
                            : [...previousValue, element])
                    .map((c) => c.name)
                    .toList()))
        : super.queryAsStream(orderFieldDescending);
  }

  Future<String?> getPostTitle(String id) async {
    final post = await get(id);
    return post?.title;
  }

  Future<int?> getLikesOfPost(String id) async {
    final post = await get(id);
    return post?.likes;
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
