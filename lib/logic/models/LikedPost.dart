import 'package:nochba/logic/interfaces/IModel.dart';

class LikedPost implements IModel {
  @override
  String id;

  LikedPost({this.id = ''});

  @override
  Map<String, dynamic> toJson() => {};

  static LikedPost fromJson(String id, Map<String, dynamic> json) =>
      LikedPost(id: id);
}
