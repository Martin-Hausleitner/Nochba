import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

enum NotificationType {
  none,
  postRequest,
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
  final bool visible;
  final bool hasSeen;

  Notification({
    this.id = '',
    required this.fromUser,
    required this.toUser,
    required this.type,
    required this.postId,
    required this.createdAt,
    this.visible = true,
    this.hasSeen = false,
  });

  @override
  Map<String, dynamic> toJson() => {
        'fromUser': fromUser,
        'toUser': toUser,
        'type': type.name,
        'postId': postId,
        'createdAt': createdAt,
        'visible': visible,
        'hasSeen': hasSeen,
      };

  factory Notification.fromJson(String id, Map<String, dynamic> json) =>
      Notification(
        id: id,
        fromUser: json['fromUser'],
        toUser: json['toUser'],
        type: getNotificationType(json['type']),
        postId: json['postId'],
        createdAt: json['createdAt'],
        visible: json['visible'],
        hasSeen: json['hasSeen'],
      );

  static NotificationType getNotificationType(String keyword) {
    if (keyword == NotificationType.postRequest.name) {
      return NotificationType.postRequest;
    } else if (keyword == NotificationType.chatRequest.name) {
      return NotificationType.chatRequest;
    } else {
      return NotificationType.none;
    }
  }
}
