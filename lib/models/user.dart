import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  final String firstName;
  final String lastName;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final Timestamp lastSeen;
  final String imageUrl;

  User({
    this.id = '', 
    required this.firstName, 
    required this.lastName, 
    required this.createdAt, 
    required this.updatedAt,
    required this.lastSeen,
    this.imageUrl = ''
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'lastSeen': lastSeen,
    'imageUrl': imageUrl,
  };

  static User fromJson(Map<String, dynamic> json) => 
  User(/*id: json['id'],*/ firstName: json['firstName'], lastName: json['lastName'], createdAt: json['createdAt'], updatedAt: json['updatedAt'], lastSeen: json['lastSeen'], imageUrl: json['imageUrl']);
  
}