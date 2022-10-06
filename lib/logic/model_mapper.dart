import 'package:nochba/logic/commonbase/util.dart';
import 'package:nochba/logic/exceptions/LogicException.dart';
import 'package:nochba/logic/exceptions/LogicExceptionType.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/interfaces/IModelMapper.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/Notification.dart';
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
  T getModelFromJson<T extends IModel>(Map<String, dynamic> json) {
    if (typeOf<T>() == typeOf<Post>()) {
      return Post.fromJson(json) as T;
    } else if (typeOf<T>() == typeOf<User>()) {
      return User.fromJson(json) as T;
    } else if (typeOf<T>() == typeOf<UserPublicInfo>()) {
      return UserPublicInfo.fromJson(json) as T;
    } else if (typeOf<T>() == typeOf<BookMark>()) {
      return BookMark.fromJson(json) as T;
    } else if (typeOf<T>() == typeOf<Notification>()) {
      return Notification.fromJson(json) as T;
    } else if (typeOf<T>() == typeOf<Comment>()) {
      return Comment.fromJson(json) as T;
    } else {
      throw LogicException(LogicExceptionType.format,
          message: 'The type ${typeOf<T>().toString()} cannot be mapped');
    }
  }
}
