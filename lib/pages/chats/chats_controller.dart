import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  ChatsController() {
    /*try {
      _user.value = FirebaseAuth.instance.currentUser;
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          _user.value = user;
        }
      });
      //_initialized = true;
    } catch (e) {
      //_error = true;
    }*/
  }

  //bool _error = false;
  //bool _initialized = false;
  //final Rx<User?> _user = null.obs;

  //bool get error => _error;
  //bool get initialized => _initialized;
  //User? get user => _user.value;

  /*void logout() async {
    await FirebaseAuth.instance.signOut();
  }*/
}
