import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/notifications/notifications_page.dart';

import '../../shared/appbar1.dart';
import '../../shared/pageV.dart';
import '../chats/chats_page.dart';
import '../new_post/new_post_page.dart';
import '../private_profile/private_profile_page.dart';
import 'dashboard_controller.dart';
import '../feed/feed_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                FeedPage(),
                NotificationsPage(),
                NewPostPage(),
                ChatsPage(),
                PrivateProfilePage(),
                // AppBar1(),
                // PageV(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            // add a box shadow
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  blurRadius: 18,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: controller.changeTabIndex,
              currentIndex: controller.tabIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.home_2_line),
                  label: 'Feed',
                  activeIcon: Icon(FlutterRemix.home_2_fill),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.notification_2_line),
                  label: 'Notifications',
                  activeIcon: Icon(FlutterRemix.notification_2_fill),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.add_circle_line),
                  label: 'New Post',
                  activeIcon: Icon(FlutterRemix.add_circle_line),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.chat_1_line),
                  label: 'Chats',
                  activeIcon: Icon(FlutterRemix.chat_1_fill),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FlutterRemix.user_line),
                  label: 'Account',
                  activeIcon: Icon(FlutterRemix.user_fill),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(FlutterRemix.user_line),
                //   label: 'Account',
                //   activeIcon: Icon(FlutterRemix.user_fill),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // _bottomNavigationBarItem({IconData icon, String label, IconData activeIcon}) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(10),
  //       topRight: Radius.circular(10),
  //     ),
  //     child: BottomNavigationBarItem(
  //       icon: Icon(Icons.home),
  //     ),
  //   );
  // }
}
