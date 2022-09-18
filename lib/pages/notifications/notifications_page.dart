import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/data_access.dart';
import 'package:locoo/logic/flutter_chat_types-3.4.5/src/user.dart' as types;
import 'package:locoo/logic/flutter_firebase_chat_core-1.6.3/src/firebase_chat_core.dart';
import 'package:locoo/pages/chats/chat.dart';
import 'package:locoo/pages/notifications/notifications_controller.dart';
import 'package:locoo/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';
import 'package:locoo/shared/ui/pretty_textfield.dart';
import 'package:locoo/logic/models/user.dart' as models;
import 'package:locoo/logic/models/Notification.dart' as models;

class NotificationsPage extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    final dataAccess = Get.find<DataAccess>();
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // A ScrollView that creates custom scroll effects using slivers.
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navTitleTextStyle:
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                      // fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      // letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
            navLargeTitleTextStyle:
                Theme.of(context).textTheme.headlineMedium?.copyWith(
                      // fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
          ),
          // barBackgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          barBackgroundColor: Theme.of(context).backgroundColor,
        ),
        child: CustomScrollView(
          // A list of sliver widgets.
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              // padding: EdgeInsetsDirectional.only(
              //   start: 7,
              //   end: 23,
              // ),

              // leading: Icon(CupertinoIcons.person_2),
              // This title is visible in both collapsed and expanded states.
              // When the "middle" parameter is omitted, the widget provided
              // in the "largeTitle" parameter is used instead in the collapsed state.
              largeTitle: Text(
                'Aktivitäten',
              ),

              trailing: Container(
                  transform: Matrix4.translationValues(14, 0, 0),
                  child: IconButton(
                    // alignment: Alignment.topRight,
                    icon: Icon(
                      FlutterRemix.menu_line,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed: () {
                      Get.snackbar('title', 'message');
                    },
                  )),
              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // This widget fills the remaining space in the viewport.
            // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder<List<models.Notification>>(
                    stream: dataAccess.getNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                            'Something went wrong: ${snapshot.error.toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w300));
                      } else if (snapshot.hasData) {
                        final notifications = snapshot.data!;

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          itemBuilder: (BuildContext context, int index) {
                            final notification = notifications.elementAt(index);

                            return NotificationElement(notification: notification);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 3),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                        // return const Text('There are no posts in the moment',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
                      }
                    },
                  ),

                  /*LocooTextField(
                      label: 'First Nam',
                      controller: TextEditingController(text: 'test'),
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 2
                          ? 'Enter min. 2 characters'
                          : null),
                  LocooTextField(
                      controller: TextEditingController(text: 'test'),
                      textInputAction: TextInputAction.next,
                      label: 'Email',
                      validator: (value) => value != null && value.length < 2
                          ? 'Enter min. 2 characters'
                          : null),
                  TextFormField(
                      controller: TextEditingController(text: 't'),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 2
                          ? 'Enter min. 2 characters'
                          : null),*/

                  // LocooCircularIconButton(
                  //   iconData: FlutterRemix.close_line,
                  //   fillColor: Theme.of(context)
                  //       .colorScheme
                  //       .onSurface
                  //       .withOpacity(0.05),
                  //   iconColor: Colors.black,
                  //   radius: 32,
                  //   onPressed: () => Navigator.pop(context),
                  // ),

                  // LocooCircularIconButton(
                  //   iconData: Icons.remove,
                  //   fillColor: Colors.red,
                  //   iconColor: Colors.white,
                  //   radius: 32,
                  //   onPressed: () {},
                  // ),
                  // LocooCircularIconButton(
                  //   iconData: Icons.add,
                  //   fillColor: Colors.green,
                  //   iconColor: Colors.white,
                  //   radius: 48,
                  //   onPressed: () {},
                  // ),
                  // LocooCircularIconButton(
                  //   iconData: Icons.check,
                  //   iconColor: Colors.green,
                  //   outlineColor: Colors.green,
                  //   onPressed: () {},
                  // ),
                  // SimpleElevatedButtonWithIcon(
                  //   label: const Text("Done"),
                  //   iconData: Icons.check,
                  //   color: Colors.green,
                  //   onPressed: () {},
                  // ),

                  // create a button with  HapticFeedback.lightImpact();
                  // LocooTextButton(
                  //   label: 'HapticFeedback.lightImpact()',
                  //   icon: Icons.check,
                  //   onPressed: () {
                  //     HapticFeedback.lightImpact();
                  //   },
                  // ),
                  // LocooTextButton(
                  //   label: 'HapticFeedback.heavyImpact();',
                  //   icon: Icons.check,
                  //   onPressed: () {
                  //     HapticFeedback.heavyImpact();
                  //   },
                  // ),
                  // LocooTextButton(
                  //   label: 'mediumImpact()',
                  //   icon: Icons.check,
                  //   onPressed: () {
                  //     HapticFeedback.mediumImpact();
                  //   },
                  // ),
                  // LocooTextButton(
                  //   label: 'selectionClick(',
                  //   icon: Icons.check,
                  //   onPressed: () {
                  //     HapticFeedback.selectionClick();
                  //   },
                  // ),
                  // LocooTextButton(
                  //   label: 'vibrate()',
                  //   icon: Icons.check,
                  //   onPressed: () {
                  //     HapticFeedback.vibrate();
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationElement extends StatelessWidget {
  const NotificationElement({Key? key, required this.notification}) : super(key: key);
  final models.Notification notification;

  @override
  Widget build(BuildContext context) {
    final dataAccess = Get.find<DataAccess>();
    return FutureBuilder<types.User?>(
            future: FirebaseChatCore.instance.user(notification.fromUser),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final otherUser = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Column(
                    children: [
                      Text('${otherUser.firstName} ${otherUser.lastName} would like to get in touch with you.'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up),
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              final room = await FirebaseChatCore.instance.createRoom(otherUser);
                              
                              await navigator.push(
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    room: room,
                                  ),
                                ),
                              );

                              await dataAccess.deleteNotification(notification.id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.thumb_down),
                            onPressed: () async {
                              await dataAccess.deleteNotification(notification.id);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
          );
  }
}
