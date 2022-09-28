import 'package:locoo/logic/models/user.dart';
import 'package:locoo/logic/repositories/GenericRepository.dart';
import 'package:locoo/logic/models/post.dart';

class PostRepository extends GenericRepository<Post> {
  PostRepository(super.resourceContext);

  Stream<List<Post>> getAllPosts(bool orderFieldDescending) {
    return super.getAll(orderFieldDescending: MapEntry('createdAt', orderFieldDescending));
  }

  Future<List<Post>> getSavedPostsOfCurrentUser() async {
    final userRepo = loadResource<User>();
    return List.empty();
    /*try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot1 = await userdataCol.doc(uid).collection('bookmarks').doc(uid).get();

      if(snapshot1.exists) {

        final posts = BookMark.fromJson(snapshot1.data()!).posts;
        final snapshot2 = await postCol.where('id', whereIn: posts).get();

        if(snapshot2.docs.isNotEmpty) {
          return snapshot2.docs.map((e) => Post.fromJson(e.data())).toList();
        } else {
          return List.empty();
        }
      } else {
        return List.empty();
      }
    } on Exception catch (e) {
      print(e);
      return List.empty();
    }*/
  }

}