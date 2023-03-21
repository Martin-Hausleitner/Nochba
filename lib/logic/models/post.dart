import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

class Post implements IModel {
  @override
  String id;
  final String uid;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;
  final String category;
  final List<String> tags;
  final int likes;
  final double range;

  // Fields of Event
  final Timestamp? eventBeginTime;
  final Timestamp? eventEndTime;
  final String? eventLocation;

  // Unmapped fields
  String userName;
  String userImageUrl;
  String suburb;

  Post({
    this.id = '',
    required this.uid,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.createdAt,
    required this.category,
    required this.tags,
    required this.likes,
    this.userName = '',
    this.userImageUrl = '',
    this.suburb = '',
    this.range = 500.0,
    this.eventLocation,
    this.eventBeginTime,
    this.eventEndTime,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'category': category,
        'tags': tags,
        'likes': likes,
        'range': range,
        'eventLocation': eventLocation,
        'eventBeginTime': eventBeginTime,
        'eventEndTime': eventEndTime,
      };

  factory Post.fromJson(String id, Map<String, dynamic> json) => Post(
        id: id,
        uid: json['uid'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        createdAt: json['createdAt'],
        category: json['category'],
        tags: List.castFrom<dynamic, String>(json[
            'tags']) /*tags: json['tags'] == null ? [] : json['tags'].map<String>((e) => e as String).toList()*/,
        likes: json['likes'] /*List.castFrom<dynamic, String>(json['liked'])*/,
        range: json['range'].toDouble(),
        eventLocation: json['eventLocation'],
        eventBeginTime: json['eventBeginTime'],
        eventEndTime: json['eventEndTime'],
      );
}
