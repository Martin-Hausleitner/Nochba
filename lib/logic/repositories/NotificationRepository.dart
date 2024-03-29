import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/exceptions/LogicException.dart';
import 'package:nochba/logic/exceptions/LogicExceptionType.dart';
import 'package:nochba/logic/flutter_firebase_chat_core-1.6.3/src/firebase_chat_core.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/pages/chats/chat.dart';

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
          whereIsEqualTo: {'toUser': resourceContext.uid, 'visible': true},
          nexus: []);
      /*return query(const MapEntry('createdAt', true), 
        whereIsEqualTo: {'toUser': resourceContext.uid}
      );*/
    } on Exception {
      rethrow;
    }
  }

  Future<void> sendPostRequestNotificationFromCurrentUser(
      String toUserId, String postId) async {
    final userPrivateInfoSettingsRepository =
        Get.find<UserPrivateInfoSettingsRepository>();

    var setting = await userPrivateInfoSettingsRepository
        .get(userPrivateInfoSettingsRepository.reference, nexus: [toUserId]);

    if (setting != null && setting.permReqBeforeChat == false) {
      var userRepository = Get.find<UserRepository>();
      var user = await userRepository.get(toUserId);
      if (user != null) {
        final room = await FirebaseChatCore.instance.createRoom(user);
        await Get.to(() => ChatPage(room: room));
      }
    } else {
      final notification = Notification(
          fromUser: resourceContext.uid,
          toUser: toUserId,
          type: NotificationType.postRequest,
          postId: postId,
          createdAt: Timestamp.now());

      await insert(notification);
    }
  }

  Future<void> sendChatRequestNotificationFromCurrentUser(
      String toUserId) async {
    final userPrivateInfoSettingsRepository =
        Get.find<UserPrivateInfoSettingsRepository>();

    var setting = await userPrivateInfoSettingsRepository
        .get(userPrivateInfoSettingsRepository.reference, nexus: [toUserId]);

    if (setting != null && setting.permReqBeforeChat == false) {
      var userRepository = Get.find<UserRepository>();
      var user = await userRepository.get(toUserId);
      if (user != null) {
        final room = await FirebaseChatCore.instance.createRoom(user);
        await Get.to(() => ChatPage(room: room));
      }
    } else {
      final notification = Notification(
          fromUser: resourceContext.uid,
          toUser: toUserId,
          type: NotificationType.chatRequest,
          postId: null,
          createdAt: Timestamp.now());

      await insert(notification);
    }
  }

  Future<void> takeNotificationOff(String id) async {
    return await updateFields(id, {'visible': false},
        nexus: [resourceContext.uid]);
  }

  Stream<bool?> hasCurrentUserAnyUnseenNotifications() {
    return any({'toUser': resourceContext.uid, 'hasSeen': false}, nexus: []);
  }

  Future<void> markNotificationsOfCurrentUserAsSeen() async {
    final notifications = await query(const MapEntry('createdAt', true),
        whereIsEqualTo: {'toUser': resourceContext.uid, 'hasSeen': false},
        nexus: []);

    for (var notification in notifications) {
      await updateFields(notification.id, {'hasSeen': true}, nexus: []);
    }
  }
}
