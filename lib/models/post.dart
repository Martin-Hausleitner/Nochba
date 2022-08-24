import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  final String user;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;
  final String category;
  final List<String> tags;
  final List<String> liked;

  Post({this.id = '', required this.user, required this.title, required this.description, this.imageUrl = '', required this.createdAt, required this.category, required this.tags, required this.liked});

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'createdAt': createdAt,
    'category': category,
    'tags': tags,
    'liked': liked,

  };

  static Post fromJson(Map<String, dynamic> json) => 
  Post(
    id: json['id'], 
    user: json['user'],
    title: json['title'],
    description: json['description'], 
    imageUrl: json['imageUrl'],
    createdAt: json['createdAt'], 
    category: json['category'], 
    tags: List.castFrom<dynamic, String>(json['tags']) /*tags: json['tags'] == null ? [] : json['tags'].map<String>((e) => e as String).toList()*/, 
    liked: List.castFrom<dynamic, String>(json['liked']),
  );
  
}