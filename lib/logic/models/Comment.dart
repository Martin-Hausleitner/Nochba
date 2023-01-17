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

  // Unmapped fields
  String userName;
  String userImageUrl;

  Comment(
      {this.id = '',
      required this.uid,
      required this.text,
      required this.createdAt,
      required this.post,
      this.likes = 0,
      this.userName = '',
      this.userImageUrl = ''});

  @override
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'text': text,
        'createdAt': createdAt,
        'post': post,
        'likes': likes
      };

  factory Comment.fromJson(String id, Map<String, dynamic> json) => Comment(
      id: id,
      uid: json['uid'],
      text: json['text'],
      createdAt: json['createdAt'],
      post: json['post'],
      likes: json['likes']);
}
