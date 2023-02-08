import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/inset_post/new_post/new_post_page.dart';
import 'package:nochba/pages/notifications/notifications_page.dart';

import '../chats/chats_page.dart';
import '../private_profile/private_profile_page.dart';
import 'dashboard_controller.dart';
import '../feed/feed_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: const [
                FeedPage(),
                NotificationsPage(),
                // NewPostPage(),
                NewPostPage(),
                ChatsPage(),
                PrivateProfilePage(),
                // AppBar1(),
                // PageV(),
              ],
            ),
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Container(
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
                backgroundColor: Theme.of(context).colorScheme.background,
                // unselectedItemColor: Colors.black,
                // selectedItemColor: Theme.of(context).primaryColor,
                onTap: controller.changeTabIndex,
                currentIndex: controller.tabIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                enableFeedback: true,
                selectedItemColor: Theme.of(context).primaryColor,

                type: BottomNavigationBarType.fixed,
                // backgroundColor: Colors.white,
                elevation: 0,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(
                      FlutterRemix.home_2_line,
                    ),
                    label: '',
                    activeIcon: Icon(
                      FlutterRemix.home_2_fill,
                      // color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.notification_2_line),
                    label: '',
                    activeIcon: Icon(
                      FlutterRemix.notification_2_fill,
                      // color: Theme.of(context).primaryColor,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(11),
                      child: const Icon(
                        //flutter plus
                        FlutterRemix.add_line,
                        size: 25,

                        color: Colors.white,
                      ),
                    ),
                    label: '',
                  ),

                  const BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.chat_1_line),
                    label: '',
                    activeIcon: Icon(
                      FlutterRemix.chat_1_fill,
                      // color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.user_line),
                    label: '',
                    activeIcon: Icon(
                      FlutterRemix.user_fill,
                      // color: Theme.of(context).primaryColor,
                    ),
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(FlutterRemix.user_line),
                  //   label: 'Account',
                  //   activeIcon: Icon(FlutterRemix.user_fill),
                  // ),
                ],
              ),
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
