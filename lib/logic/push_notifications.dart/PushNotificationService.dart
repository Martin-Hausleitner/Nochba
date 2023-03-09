import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getToken() async => await _fcm.getToken();

  // Future initialize() async {
  //   // if (Platform.isIOS) {
  //   //   _fcm.requestNotificationPermissions(IosNotificationSettings());
  //   // }
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //       // _showItemDialog(message);
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       // _navigateToItemDetail(message);
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       // _navigateToItemDetail(message);
  //     },
  //   );
  // }
}
