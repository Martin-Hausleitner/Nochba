import 'package:get/get.dart';
import 'package:nochba/logic/flutter_firebase_chat_core-1.6.3/flutter_firebase_chat_core.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/NotificationRepository.dart';
import 'package:nochba/logic/repositories/PostRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';
import 'package:nochba/pages/chats/chat.dart';

class NotificationsController extends GetxController {
  final notificationRepository = Get.find<NotificationRepository>();
  final userRepository = Get.find<UserRepository>();
  final postRepository = Get.find<PostRepository>();

  Stream<List<Notification>> getNotificationsOfCurrentUser() {
    try {
      return notificationRepository.getNotifiactionsOfCurrentUser();
    } on Exception {
      return Stream.error(Error);
    }
  }

  Future<void> deleteNotification(notificationId) {
    try {
      return notificationRepository.delete(notificationId);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<User?> getUser(String id) {
    try {
      return userRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<Post?> getPost(String id) {
    try {
      return postRepository.get(id);
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> onAccept(Notification notification, User user) async {
    try {
      final room = await FirebaseChatCore.instance.createRoom(user);
      await notificationRepository.takeNotificationOff(notification.id);
      await Get.to(() => ChatPage(room: room));
    } on Exception {
      return Future.error(Error);
    }
  }

  Future<void> onDecline(Notification notification) async {
    try {
      return notificationRepository.takeNotificationOff(notification.id);
    } on Exception {
      return Future.error(Error);
    }
  }
}
