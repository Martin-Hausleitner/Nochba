import 'package:nochba/logic/commonbase/util.dart';
import 'package:nochba/logic/exceptions/LogicException.dart';
import 'package:nochba/logic/exceptions/LogicExceptionType.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/interfaces/IModelMapper.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/LikedComment.dart';
import 'package:nochba/logic/models/LikedPost.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/Token.dart';
import 'package:nochba/logic/models/UserInternInfoAddress.dart';
import 'package:nochba/logic/models/UserPrivateInfoAddress.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/UserPrivateInfoSettings.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart';

class ModelMapper implements IModelMapper {
  @override
  Map<String, dynamic> getJsonFromModel<T extends IModel>(T model) {
    if (typeOf<T>() == typeOf<Post>()) {
      return (model as Post).toJson();
    } else if (typeOf<T>() == typeOf<User>()) {
      return (model as User).toJson();
    } else if (typeOf<T>() == typeOf<UserPublicInfo>()) {
      return (model as UserPublicInfo).toJson();
    } else if (typeOf<T>() == typeOf<BookMark>()) {
      return (model as BookMark).toJson();
    } else if (typeOf<T>() == typeOf<UserPrivateInfoName>()) {
      return (model as UserPrivateInfoName).toJson();
    } else if (typeOf<T>() == typeOf<UserPrivateInfoSettings>()) {
      return (model as UserPrivateInfoSettings).toJson();
    } else if (typeOf<T>() == typeOf<UserPrivateInfoAddress>()) {
      return (model as UserPrivateInfoAddress).toJson();
    } else if (typeOf<T>() == typeOf<UserInternInfoAddress>()) {
      return (model as UserInternInfoAddress).toJson();
    } else if (typeOf<T>() == typeOf<LikedPost>()) {
      return (model as LikedPost).toJson();
    } else if (typeOf<T>() == typeOf<LikedComment>()) {
      return (model as LikedComment).toJson();
    } else if (typeOf<T>() == typeOf<Token>()) {
      return (model as Token).toJson();
    } else if (typeOf<T>() == typeOf<Notification>()) {
      return (model as Notification).toJson();
    } else if (typeOf<T>() == typeOf<Comment>()) {
      return (model as Comment).toJson();
    } else {
      throw LogicException(LogicExceptionType.format,
          message: 'The type ${typeOf<T>().toString()} cannot be mapped');
    }
  }

  @override
  T getModelFromJson<T extends IModel>(String id, Map<String, dynamic> json) {
    if (typeOf<T>() == typeOf<Post>()) {
      return Post.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<User>()) {
      return User.fromJson(json) as T;
    } else if (typeOf<T>() == typeOf<UserPublicInfo>()) {
      return UserPublicInfo.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<BookMark>()) {
      return BookMark.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<UserPrivateInfoName>()) {
      return UserPrivateInfoName.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<UserPrivateInfoSettings>()) {
      return UserPrivateInfoSettings.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<UserPrivateInfoAddress>()) {
      return UserPrivateInfoAddress.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<UserInternInfoAddress>()) {
      return UserInternInfoAddress.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<LikedPost>()) {
      return LikedPost.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<LikedComment>()) {
      return LikedComment.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<Token>()) {
      return Token.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<Notification>()) {
      return Notification.fromJson(id, json) as T;
    } else if (typeOf<T>() == typeOf<Comment>()) {
      return Comment.fromJson(id, json) as T;
    } else {
      throw LogicException(LogicExceptionType.format,
          message: 'The type ${typeOf<T>().toString()} cannot be mapped');
    }
  }
}
