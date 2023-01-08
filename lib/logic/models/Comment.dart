import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

class Comment implements IModel {
  @override
  String id;
  final String uid;
  final String text;
  final Timestamp createdAt;
  final String post;
  final int likes;

  Comment(
      {this.id = '',
      required this.uid,
      required this.text,
      required this.createdAt,
      required this.post,
      this.likes = 0});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'text': text,
        'createdAt': createdAt,
        'post': post,
        'likes': likes
      };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      id: json['id'],
      uid: json['uid'],
      text: json['text'],
      createdAt: json['createdAt'],
      post: json['post'],
      likes: json['likes']);
}
