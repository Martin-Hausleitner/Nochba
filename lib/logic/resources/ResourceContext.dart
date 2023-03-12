import 'package:firebase_auth/firebase_auth.dart';
import 'package:nochba/logic/exceptions/LogicException.dart';
import 'package:nochba/logic/exceptions/LogicExceptionType.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/model_converter/model_mapper.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/LikedComment.dart';
import 'package:nochba/logic/models/LikedPost.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/Report.dart';
import 'package:nochba/logic/models/Token.dart';
import 'package:nochba/logic/models/UserInternInfoAddress.dart';
import 'package:nochba/logic/models/UserPrivateInfoAddress.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/UserPrivateInfoSettings.dart';
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

    ModelMapper modelMapper = ModelMapper();

    postResource = Resource<Post>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    userResource = Resource<models.User>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    userPublicInfoResource = Resource<UserPublicInfo>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    bookMarkResource = Resource<BookMark>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    userPrivateInfoNameResource = Resource<UserPrivateInfoName>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    userPrivateInfoSettingsResource = Resource<UserPrivateInfoSettings>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    userPrivateInfoAddressResource = Resource<UserPrivateInfoAddress>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);

    userInternInfoAddressResource = Resource<UserInternInfoAddress>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    likedPostResource = Resource<LikedPost>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    likedCommentResource = Resource<LikedComment>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);

    tokenResource = Resource<Token>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    notificationResource = Resource<Notification>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
    commentResource = Resource<Comment>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);

    reportResource = Resource<Report>(
        getCollectionName: getCollectionName(), modelMapper: modelMapper);
  }

  final config = const ResourceConfig();

  User? firebaseUser = FirebaseAuth.instance.currentUser;
  String get uid => firebaseUser != null ? firebaseUser!.uid : '';
  //bool get userIsPresent => firebaseUser != null;

  late Resource<Post> postResource;
  late Resource<models.User> userResource;
  late Resource<UserPublicInfo> userPublicInfoResource;
  late Resource<BookMark> bookMarkResource;
  late Resource<UserPrivateInfoName> userPrivateInfoNameResource;
  late Resource<UserPrivateInfoSettings> userPrivateInfoSettingsResource;
  late Resource<UserPrivateInfoAddress> userPrivateInfoAddressResource;
  late Resource<UserInternInfoAddress> userInternInfoAddressResource;
  late Resource<LikedPost> likedPostResource;
  late Resource<LikedComment> likedCommentResource;
  late Resource<Token> tokenResource;
  late Resource<Notification> notificationResource;
  late Resource<Comment> commentResource;
  late Resource<Report> reportResource;

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
        } else if ((type == typeOf<BookMark>() ||
                type == typeOf<UserPrivateInfoName>() ||
                type == typeOf<UserPrivateInfoSettings>() ||
                type == typeOf<UserPrivateInfoAddress>()) &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.userPrivateInfoCollectionName}';
        } else if (type == typeOf<UserInternInfoAddress>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.userInternInfoCollectionName}';
        } else if (type == typeOf<LikedPost>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.userPrivateInfoCollectionName}/record/${config.likedPostsCollectionName}';
        } else if (type == typeOf<LikedComment>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.userPrivateInfoCollectionName}/record/${config.likedCommentsCollectionName}';
        } else if (type == typeOf<Token>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.usersCollectionName}/${nexus[0]}/${config.tokenCollectionName}';
        } else if (type == typeOf<Notification>()) {
          return config.notificationsCollectionName;
        } else if (type == typeOf<Comment>() &&
            nexus != null &&
            nexus.length == 1) {
          return '${config.postsCollectionName}/${nexus[0]}/${config.commentsCollectionName}';
        } else if (type == typeOf<Report>()) {
          return config.reportsCollectionName;
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
    } else if (typeOf<T>() == typeOf<UserPrivateInfoName>()) {
      return userPrivateInfoNameResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<UserPrivateInfoSettings>()) {
      return userPrivateInfoSettingsResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<UserPrivateInfoAddress>()) {
      return userPrivateInfoAddressResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<UserInternInfoAddress>()) {
      return userInternInfoAddressResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<LikedPost>()) {
      return likedPostResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<LikedComment>()) {
      return likedCommentResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<Token>()) {
      return tokenResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<Notification>()) {
      return notificationResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<Comment>()) {
      return commentResource as Resource<T>;
    } else if (typeOf<T>() == typeOf<Report>()) {
      return reportResource as Resource<T>;
    } else {
      throw const LogicException(LogicExceptionType.dataAccess,
          message: 'Data-Access not available');
    }
  }
}
