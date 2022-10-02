import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

enum NotificationType {
  none,
  chatRequest,
}

class Notification implements IModel {
  @override
  String id;
  final String fromUser;
  final String toUser;
  final NotificationType type;
  final String? postId;
  final Timestamp createdAt;

  Notification({
    this.id = '',
    required this.fromUser,
    required this.toUser,
    required this.type,
    required this.postId,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUser': fromUser,
        'toUser': toUser,
        'type': type.name,
        'postId': postId,
        'createdAt': createdAt,
      };

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'],
        fromUser: json['fromUser'],
        toUser: json['toUser'],
        type: getNotificationType(json['type']),
        postId: json['postId'],
        createdAt: json['createdAt'],
      );

  static NotificationType getNotificationType(String keyword) {
    if (keyword == NotificationType.chatRequest.name) {
      return NotificationType.chatRequest;
    } else {
      return NotificationType.none;
    }
  }
}
