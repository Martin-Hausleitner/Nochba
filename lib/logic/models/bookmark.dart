import 'package:nochba/logic/interfaces/IModel.dart';

class BookMark implements IModel {
  @override
  String id;
  final List<String> posts;

  BookMark({this.id = '', required this.posts});

  @override
  Map<String, dynamic> toJson() => {
         'posts': posts,
      };

  static BookMark fromJson(String id, Map<String, dynamic> json) =>
      BookMark(id: id, posts: List.castFrom<dynamic, String>(json['posts']));
}
