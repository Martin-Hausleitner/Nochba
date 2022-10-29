import 'package:get/get.dart';
import 'package:nochba/logic/models/bookmark.dart';
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

      final oldImageName = await _storageService
          .downloadPostImageNameFromStorage(postBeforeDelete!.imageUrl);
      final newImageName = await _storageService
          .downloadPostImageNameFromStorage(model.imageUrl);

      if ((oldImageName.isNotEmpty &&
              newImageName.isNotEmpty &&
              oldImageName != newImageName) ||
          (oldImageName.isNotEmpty && newImageName.isEmpty)) {
        _storageService.deletePostImageFromStorage(oldImageName);
      }
    }
  }

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
