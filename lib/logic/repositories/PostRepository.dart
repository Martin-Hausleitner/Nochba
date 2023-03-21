import 'package:algolia/algolia.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/algolia/AlgoliaApplication.dart';
import 'package:nochba/logic/models/PostFilter.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/repositories/BookMarkRepository.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/models/post.dart';
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
            post.suburb = user.suburb ?? '';
          }

          return post;
        }).toList()));
  }

  @override
  Future<List<Post>> processFutureListResult(Future<List<Post>> result) async {
    final userRepository = Get.find<UserRepository>();

    final posts = await result;

    return Future.wait(posts.map((post) async {
      final user = await userRepository.get(post.uid);

      if (user != null) {
        post.userName = user.fullName ?? '';
        post.userImageUrl = user.imageUrl ?? '';
        post.suburb = user.suburb ?? '';
      }

      return post;
    }).toList());
  }

  Future<List<Post>> getPosts(String searchInput, PostFilter postFilter) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
      'getUserPostsWithinRange',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 20),
      ),
    );

    final callResult =
        await callable.call(<String, dynamic>{'range': postFilter.range});

    final postIds = List<String>.from(callResult.data);

    final orderFieldDescending = MapEntry(
        postFilter.postFilterSortBy == PostFilterSortBy.date
            ? 'createdAt'
            : postFilter.postFilterSortBy == PostFilterSortBy.likes
                ? 'likes'
                : '',
        postFilter.isOrderDescending);

    final filteredCategories = postFilter.categories
        .fold<List<CategoryOptions>>(
            [],
            (previousValue, element) => CategoryModul.isMainCategory(element) &&
                    CategoryModul.getSubCategoriesOfMainCategory(element)
                        .isNotEmpty
                ? [
                    ...previousValue,
                    ...CategoryModul.getSubCategoriesOfMainCategory(element)
                  ]
                : [...previousValue, element])
        .map((c) => c.name)
        .toList();

    const Algolia algolia = AlgoliaApplication.algolia;
    AlgoliaQuery query = algolia.instance.index("posts").query(searchInput);

    if (filteredCategories.isNotEmpty) {
      final categoryFilter =
          'category:${filteredCategories.join(' OR category:')}';

      query = query.filters(categoryFilter);
    }

    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    final filteredPostIds =
        results.fold<List<String>>([], (previousValue, element) {
      return postIds.contains(element.objectID)
          ? [...previousValue, element.objectID]
          : previousValue;
    });

    return filteredPostIds.isNotEmpty
        ? await this.query(orderFieldDescending,
            whereIn: MapEntry('id', filteredPostIds))
        : [];
  }

  Future<List<Post>> queryPosts(PostFilter postFilter) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
      'getUserPostsWithinRange',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 20),
      ),
    );

    final postIds =
        await callable.call(<String, dynamic>{'range': postFilter.range});

    final orderFieldDescending = MapEntry(
        postFilter.postFilterSortBy == PostFilterSortBy.date
            ? 'createdAt'
            : postFilter.postFilterSortBy == PostFilterSortBy.likes
                ? 'likes'
                : '',
        postFilter.isOrderDescending);

    final filteredCategories = postFilter.categories
        .fold<List<CategoryOptions>>(
            [],
            (previousValue, element) => CategoryModul.isMainCategory(element) &&
                    CategoryModul.getSubCategoriesOfMainCategory(element)
                        .isNotEmpty
                ? [
                    ...previousValue,
                    ...CategoryModul.getSubCategoriesOfMainCategory(element)
                  ]
                : [...previousValue, element])
        .map((c) => c.name)
        .toList();

    final queriedPosts = await query(orderFieldDescending,
        whereIn: MapEntry('id', postIds.data));

    return filteredCategories.isEmpty
        ? queriedPosts
        : queriedPosts
            .where((post) => filteredCategories.contains(post.category))
            .toList();
  }

  Future<List<Post>> searchPosts(
      String searchInput, PostFilter postFilter) async {
    final orderFieldDescending = MapEntry(
        postFilter.postFilterSortBy == PostFilterSortBy.date
            ? 'createdAt'
            : postFilter.postFilterSortBy == PostFilterSortBy.likes
                ? 'likes'
                : '',
        postFilter.isOrderDescending);

    const Algolia algolia = AlgoliaApplication.algolia;
    AlgoliaQuery query = algolia.instance.index("posts").query(searchInput);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    final postIds = results.map((snapshot) => snapshot.objectID).toList();

    return postIds.isNotEmpty
        ? super.query(orderFieldDescending, whereIn: MapEntry('id', postIds)
            // 'category': postFilter.categories
            //     .fold<List<CategoryOptions>>(
            //         [],
            //         (previousValue, element) =>
            //             CategoryModul.isMainCategory(element) &&
            //                     CategoryModul.getSubCategoriesOfMainCategory(
            //                             element)
            //                         .isNotEmpty
            //                 ? [
            //                     ...previousValue,
            //                     ...CategoryModul.getSubCategoriesOfMainCategory(
            //                         element)
            //                   ]
            //                 : [...previousValue, element])
            //     .map((c) => c.name)
            //     .toList(),
            )
        : Future.value(List.empty());
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

  Stream<List<Post>> getPostsOfUserAsStream(String uid) {
    return queryAsStream(const MapEntry('createdAt', true),
        whereIsEqualTo: {'uid': uid});
  }

  Future<List<Post>> getMarkedPostsOfCurrentUser() async {
    final bookMarkRepository = Get.find<BookMarkRepository>();
    final uid = resourceContext.uid;
    final bookMark = await bookMarkRepository
        .get(bookMarkRepository.reference, nexus: [uid]);
    if (bookMark != null && bookMark.posts.isNotEmpty) {
      final postIds = bookMark.posts;
      final posts = await query(const MapEntry('createdAt', true),
          whereIn: MapEntry('id', postIds));

      return posts.isNotEmpty ? posts : List.empty();
    }
    return List.empty();
  }
}
