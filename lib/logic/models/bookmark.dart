import 'package:nochba/logic/interfaces/IModel.dart';

class BookMark implements IModel {
  @override
  String id;
  final List<String> posts;

  BookMark({this.id = '', required this.posts});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'posts': posts,
      };

  static BookMark fromJson(Map<String, dynamic> json) => BookMark(
      id: json['id'], posts: List.castFrom<dynamic, String>(json['posts']));
}
