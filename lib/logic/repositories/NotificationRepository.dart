import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/exceptions/LogicException.dart';
import 'package:nochba/logic/exceptions/LogicExceptionType.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class NotificationRepository extends GenericRepository<Notification> {
  NotificationRepository(super.resourceContext);

  @override
  Future validate(Notification? model, AccessMode accessMode) async {
    if (accessMode == AccessMode.insert && model != null) {
      Notification? notification;
      if (model.type == NotificationType.postRequest) {
        notification = await getWhere({
          'toUser': model.toUser,
          'fromUser': model.fromUser,
          'postId': model.postId,
        }, nexus: [
          model.toUser
        ]);
      } else if (model.type == NotificationType.chatRequest) {
        notification = await getWhere({
          'toUser': model.toUser,
          'fromUser': model.fromUser,
          'postId': null,
        }, nexus: [
          model.toUser
        ]);
      }

      if (notification != null) {
        throw const LogicException(LogicExceptionType.alreadyExists,
            message: 'Notification already exists');
      }
    }
  }

  Stream<List<Notification>> getNotifiactionsOfCurrentUser() {
    try {
      return queryAsStream(const MapEntry('createdAt', true),
          whereIsEqualTo: {'visible': true}, nexus: [resourceContext.uid]);
      /*return query(const MapEntry('createdAt', true), 
        whereIsEqualTo: {'toUser': resourceContext.uid}
      );*/
    } on Exception {
      rethrow;
    }
  }

  Future<void> sendPostRequestNotificationFromCurrentUser(
      String toUserId, String postId) async {
    final notification = Notification(
        fromUser: resourceContext.uid,
        toUser: toUserId,
        type: NotificationType.postRequest,
        postId: postId,
        createdAt: Timestamp.now());

    return await insert(notification, nexus: [toUserId]);
  }

  Future<void> sendChatRequestNotificationFromCurrentUser(
      String toUserId) async {
    final notification = Notification(
        fromUser: resourceContext.uid,
        toUser: toUserId,
        type: NotificationType.chatRequest,
        postId: null,
        createdAt: Timestamp.now());

    return await insert(notification, nexus: [toUserId]);
  }

  Future<void> takeNotificationOff(String id) {
    return updateFields(id, {'visible': false}, nexus: [resourceContext.uid]);
  }
}
