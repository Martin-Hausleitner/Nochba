import 'package:firebase_auth/firebase_auth.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/model_mapper.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart' as models;
import 'package:nochba/logic/resources/Resource.dart';
import 'package:nochba/logic/resources/ResourceConfig.dart';
import 'package:nochba/logic/commonbase/util.dart';

class ResourceContext {
  ResourceContext() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });

    postResource = Resource<Post>(
        getCollectionName: getCollectionName(), modelMapper: ModelMapper());
    userResource = Resource<models.User>(
        getCollectionName: getCollectionName(), modelMapper: ModelMapper());
    userPublicInfoResource = Resource<UserPublicInfo>(
        getCollectionName: getCollectionName(), modelMapper: ModelMapper());
    bookMarkResource = Resource<BookMark>(
        getCollectionName: getCollectionName(), modelMapper: ModelMapper());
    notificationResource = Resource<Notification>(
        getCollectionName: getCollectionName(), modelMapper: ModelMapper());
    commentResource = Resource<Comment>(
        getCollectionName: getCollectionName(), modelMapper: ModelMapper());
  }

  final config = const ResourceConfig();

  User? firebaseUser = FirebaseAuth.instance.currentUser;
  String get uid => firebaseUser != null ? firebaseUser!.uid : '';
  //bool get userIsPresent => firebaseUser != null;

  late Resource<Post> postResource;
  late Resource<models.User> userResource;
  late Resource<UserPublicInfo> userPublicInfoResource;
  late Resource<BookMark> bookMarkResource;
  late Resource<Notification> notificationResource;
  late Resource<Comment> commentResource;

  String Function(Type type, {List<String>? nexus}) getCollectionName() =>
      (Type type, {List<String>? nexus}) {
        if (type == typeOf<Post>()) {
          return config.postsCollectionName;
        } else if (type == typeOf<models.User>()) {
          return config.usersCollectionName;
        } else if (type == typeOf<UserPublicInfo>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.userPublicInfoCollectionName}';
        } else if (type == typeOf<BookMark>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.bookMarksCollectionName}';
        } else if (type == typeOf<Notification>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.notificationsCollectionName}';
        } else if (type == typeOf<Comment>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.postsCollectionName}/${nexus[0]}/${config.commentsCollectionName}';
        } else {
          return '';
        }
      };

  Resource<T> getResource<T extends IModel>() {
    if (typeOf<T>() == typeOf<Post>()) {
      return postResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<models.User>()) {
      return userResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<UserPublicInfo>()) {
      return userPublicInfoResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<BookMark>()) {
      return bookMarkResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<Notification>()) {
      return notificationResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<Comment>()) {
      return commentResource as Resource<T>;
    } else {
      throw Exception('Data-Access not available');
    }
  }
}
