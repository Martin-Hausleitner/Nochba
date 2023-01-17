import 'package:nochba/logic/interfaces/IModel.dart';

class LikedComment implements IModel {
  @override
  String id;
  String post;

  LikedComment({this.id = '', required this.post});

  @override
  Map<String, dynamic> toJson() => {'post': post};

  static LikedComment fromJson(String id, Map<String, dynamic> json) =>
      LikedComment(id: id, post: json['post']);
}
