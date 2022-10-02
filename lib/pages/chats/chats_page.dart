import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nochba/pages/chats/chats_controller.dart';
import 'package:nochba/pages/chats/widgets/chat_element.dart';

import 'chat.dart';
import 'firebase_options.dart';
import 'users.dart';
import 'util.dart';

import 'package:nochba/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart'
    as types;
import 'package:nochba/logic/flutter_firebase_chat_core-1.6.3/flutter_firebase_chat_core.dart'
    as chat;

class ChatsPage extends GetView<ChatsController> {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Nachrichten',
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    splashRadius: 0.01,
                    icon: Icon(
                      Icons.add,
                      size: 24,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                    onPressed: () {
                      Get.to(() => const UsersPage());
                    },
                    padding:
                        EdgeInsets.only(right: 3, left: 0, top: 3, bottom: 0),
                    alignment: Alignment.centerRight,
                  ),
                  IconButton(
                    splashRadius: 0.01,
                    icon: Icon(
                      FlutterRemix.pencil_line,
                      size: 24,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                    onPressed: () {
                      Get.snackbar('Edit', 'Chat');
                    },
                    padding:
                        EdgeInsets.only(right: 3, left: 0, top: 3, bottom: 0),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // This widget fills the remaining space in the viewport.
            // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
            SliverFillRemaining(
              child: StreamBuilder<List<types.Room>>(
                stream: chat.FirebaseChatCore.instance.rooms(),
                initialData: const [],
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                      //center
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        // add a forum icon
                        Icon(
                          Icons.forum_outlined,
                          size: 100,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Noch keine Nachrichten',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.15),
                                  ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final room = snapshot.data![index];

                      return InkWell(
                        // splashColor: Colors.red,
                        onTap: () {
                          /*Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                room: room,
                              ),
                            ),
                          );*/
                          Get.to(
                            () => ChatPage(room: room),
                            transition: Transition.cupertino,
                          );
                        },
                        // child: Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 16,
                        //     vertical: 8,
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Obx(() => _buildAvatar(room)),
                        //       Text(room.name ?? ''),
                        //     ],
                        //   ),
                        // ),
                        child: Ink(
                          child: ChatElement(
                            roomName: room.name ?? '',
                            imageUrl: room.imageUrl ?? '',
                            lastMessage:
                                'sdssdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsddsdsdsdsd',
                            time: '',
                            notificationCount: 9,
                          ),
                          // red Continaer
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(types.Room room) {
    final controller = Get.find<ChatsController>();
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != controller.user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}

/*
class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Text('Error schau bei if (_error)');
    }

    if (!_initialized) {
      return Container();
    }
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
                'Nachrichten',
              ),

              trailing: Row(
                children: [
                  Container(
                    transform: Matrix4.translationValues(14, 0, 0),
                    child: IconButton(
                      // alignment: Alignment.topRight,
                      icon: Icon(
                        FlutterRemix.pencil_line,
                        size: 24,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer,
                      ),
                      onPressed: () {
                        Get.snackbar('title', 'message');
                      },
                    )
                  ),
                  Container(
                    transform: Matrix4.translationValues(14, 0, 0),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: _user == null
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => const UsersPage(),
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // This widget fills the remaining space in the viewport.
            // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
            SliverFillRemaining(
              child: _user == null
                  ? Container()
                  : StreamBuilder<List<types.Room>>(
                      stream: chat.FirebaseChatCore.instance.rooms(),
                      initialData: const [],
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              bottom: 200,
                            ),
                            child: const Text('No rooms'),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final room = snapshot.data![index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      room: room,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    _buildAvatar(room),
                                    Text(room.name ?? ''),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //   return Scaffold(
  //     body: CustomScrollView(
  //       slivers: <Widget>[
  //         SliverAppBar(
  //           pinned: true,
  //           snap: true,
  //           floating: true,
  //           shadowColor: Colors.transparent,
  //           backgroundColor: Colors.white,
  //           expandedHeight: 160.0,
  //           forceElevated: true,
  //           actions: [
  //             // IconButton(
  //             //   icon: const Icon(FlutterRemix.pencil_line),
  //             //   color: Colors.black,
  //             //   onPressed: () {
  //             //     Get.snackbar('dsfdsf', 'dsfdsf');
  //             //   },
  //             // ),
  //             IconButton(
  //               icon: const Icon(Icons.add, color: Colors.black),
  //               onPressed: _user == null
  //                   ? null
  //                   : () {
  //                       Navigator.of(context).push(
  //                         MaterialPageRoute(
  //                           fullscreenDialog: true,
  //                           builder: (context) => const UsersPage(),
  //                         ),
  //                       );
  //                     },
  //             ),
  //             IconButton(
  //               icon: const Icon(
  //                 Icons.logout,
  //                 color: Colors.black,
  //               ),
  //               onPressed: _user == null ? null : logout,
  //             ),
  //           ],
  //           flexibleSpace: FlexibleSpaceBar(
  //               title: Text(
  //                 'Nachrichten',
  //                 style: GoogleFonts.inter(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.w800,
  //                   letterSpacing: -0.5,
  //                   color: Color.fromARGB(255, 22, 22, 22),
  //                 ),
  //               ),
  //               titlePadding: EdgeInsets.only(left: 15, bottom: 15)),
  //         ),
  // SliverFillRemaining(
  //   child: _user == null
  //       ? Container(
  //           alignment: Alignment.center,
  //           margin: const EdgeInsets.only(
  //             bottom: 200,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Text('Not authenticated'),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).push(
  //                     MaterialPageRoute(
  //                       fullscreenDialog: true,
  //                       builder: (context) => const LoginPage(),
  //                     ),
  //                   );
  //                 },
  //                 child: const Text('Login'),
  //               ),
  //             ],
  //           ),
  //         )
  //       : StreamBuilder<List<types.Room>>(
  //           stream: FirebaseChatCore.instance.rooms(),
  //           initialData: const [],
  //           builder: (context, snapshot) {
  //             if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //               return Container(
  //                 alignment: Alignment.center,
  //                 margin: const EdgeInsets.only(
  //                   bottom: 200,
  //                 ),
  //                 child: const Text('No rooms'),
  //               );
  //             }

  //             return ListView.builder(
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (context, index) {
  //                 final room = snapshot.data![index];

  //                 return GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context).push(
  //                       MaterialPageRoute(
  //                         builder: (context) => ChatPage(
  //                           room: room,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 16,
  //                       vertical: 8,
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         _buildAvatar(room),
  //                         Text(room.name ?? ''),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void initializeFlutterFire() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          name: "THIS",
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
*/