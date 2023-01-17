import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/flutter_chat_ui-1.6.4/flutter_chat_ui.dart';
import 'package:nochba/logic/models/PostFilter.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/repositories/UserInternInfoAddressRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
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

  @override
  Stream<List<Post>> processStreamListResult(Stream<List<Post>> result) {
    final userRepository = Get.find<UserRepository>();

    return result.asyncMap((posts) => Future.wait(posts.map((post) async {
          final user = await userRepository.get(post.uid);

          if (user != null) {
            post.userName = user.fullName ?? '';
            post.userImageUrl = user.imageUrl ?? '';
          }

          return post;
        }).toList()));
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
    /*.asyncMap((posts) async {
            final userInternInfoAddressRepository =
                Get.find<UserInternInfoAddressRepository>();
            final center = await userInternInfoAddressRepository
                .getField<Map<String, dynamic>>(
                    userInternInfoAddressRepository.reference, 'position',
                    nexus: [resourceContext.uid]);

            // Get.snackbar('Center',
            //     center != null ? center['geopoint'].toString() : 'Null');

            List<String> nearUids = [];
            if (center != null) {
              GeoPoint gp = center['geopoint'];
              try {
                final gq = await userInternInfoAddressRepository.geoQuery(
                    GeoFirePoint(gp.latitude, gp.longitude),
                    postFilter.radius,
                    'position',
                    nexus: [resourceContext.uid]);
                nearUids = gq.map((info) => info.id).toList();
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            }
            Get.snackbar(nearUids.length.toString(), nearUids.toString());

            return posts.where((post) => nearUids.contains(post.uid)).toList();
          });*/
  }

  Future<String?> getPostTitle(String id) async {
    final post = await get(id);
    return post?.title;
  }

  Stream<int?> getLikesOfPost(String id) {
    return getFieldAsStream(id, 'likes');
  }

  Future<List<Post>> getPostsOfCurrentUser() async {
    return await query(const MapEntry('createdAt', true),
        whereIsEqualTo: {'uid': resourceContext.uid});
  }

  Future<List<Post>> getMarkedPostsOfCurrentUser() async {
    final bookMarkRepository = Get.find<BookMarkRepository>();
    final uid = resourceContext.uid;
    final bookMark = await bookMarkRepository
        .get(bookMarkRepository.reference, nexus: [uid]);
    Get.snackbar(
        bookMark == null ? 'Null' : bookMark.toString(),
        bookMark != null && bookMark.posts.isNotEmpty
            ? bookMark.posts.length.toString()
            : '0');
    if (bookMark != null && bookMark.posts.isNotEmpty) {
      final postIds = bookMark.posts;
      final posts = await query(const MapEntry('createdAt', true),
          whereIn: MapEntry('id', postIds));

      return posts.isNotEmpty ? posts : List.empty();
    }
    return List.empty();
  }
}
