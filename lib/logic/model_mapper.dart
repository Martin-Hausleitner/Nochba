import 'package:locoo/logic/commonbase/util.dart';
import 'package:locoo/logic/interfaces/IModel.dart';
import 'package:locoo/logic/interfaces/IModelMapper.dart';
import 'package:locoo/logic/models/Comment.dart';
import 'package:locoo/logic/models/Notification.dart';
import 'package:locoo/logic/models/post.dart';
import 'package:locoo/logic/models/user.dart';

class ModelMapper implements IModelMapper {
  @override
  Map<String, dynamic> getJsonFromModel<T extends IModel>(T model) {
    if(typeOf<T>() == typeOf<Post>()) {
      return (model as Post).toJson();
    }
    else if(typeOf<T>() == typeOf<User>()) {
      return (model as User).toJson();
    }
    else if(typeOf<T>() == typeOf<Notification>()) {
      return (model as Notification).toJson();
    }
    else if(typeOf<T>() == typeOf<Comment>()) {
      return (model as Comment).toJson();
    }
    else {
      throw const FormatException();
    }
  }

  @override
  T getModelFromJson<T extends IModel>(Map<String, dynamic> json) {
    if(typeOf<T>() == typeOf<Post>()) {
      return Post.fromJson(json) as T;
    }
    else if(typeOf<T>() == typeOf<User>()) {
      return User.fromJson(json) as T;
    }
    else if(typeOf<T>() == typeOf<Notification>()) {
      return Notification.fromJson(json) as T;
    }
    else if(typeOf<T>() == typeOf<Comment>()) {
      return Comment.fromJson(json) as T;
    }
    else {
      throw const FormatException();
    }
  }
}