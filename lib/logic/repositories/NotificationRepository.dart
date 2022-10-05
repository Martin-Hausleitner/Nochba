import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class NotificationRepository extends GenericRepository<Notification> {
  NotificationRepository(super.resourceContext);

  @override
  Future validate(Notification? model, AccessMode accessMode) async {
    if (accessMode == AccessMode.insert && model != null) {
      final notification = await getWhere({
        'toUser': model.toUser,
        'fromUser': model.fromUser,
        'postId': model.postId,
      }, nexus: [
        model.toUser
      ]);
      if (notification != null) {
        throw Exception('Notification already exists');
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

  Future<void> insertNotificationFromCurrentUser(
      String toUserId, String postId) async {
    final notification = Notification(
        fromUser: resourceContext.uid,
        toUser: toUserId,
        type: NotificationType.chatRequest,
        postId: postId,
        createdAt: Timestamp.now());

    return await insert(notification, nexus: [toUserId]);
  }

  Future<void> takeNotificationOff(String id) {
    return updateFields(id, {'visible': false}, nexus: [resourceContext.uid]);
  }
}
