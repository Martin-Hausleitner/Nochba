import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'users.dart';
import 'util.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navTitleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            navLargeTitleTextStyle: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
          barBackgroundColor: Colors.white,
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
                'Einstellungen',
              ),
              
              // padding left 10
              padding: EdgeInsetsDirectional.only(
                start: 12,
                end: 10,
              ),

              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // add a Silverlist with SettingsCard
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      'Konto',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(height: 15),
                  _user == null
                ? NotAuth()
                : StreamBuilder<List<types.Room>>(
                    stream: FirebaseChatCore.instance.rooms(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: <Widget>[
    //       SliverAppBar(
    //         pinned: true,
    //         snap: true,
    //         floating: true,
    //         shadowColor: Colors.transparent,
    //         backgroundColor: Colors.white,
    //         expandedHeight: 160.0,
    //         forceElevated: true,
    //         actions: [
    //           IconButton(
    //             icon: const Icon(Icons.add, color: Colors.black),
    //             onPressed: _user == null
    //                 ? null
    //                 : () {
    //                     Navigator.of(context).push(
    //                       MaterialPageRoute(
    //                         fullscreenDialog: true,
    //                         builder: (context) => const UsersPage(),
    //                       ),
    //                     );
    //                   },
    //           ),
    //           IconButton(
    //             icon: const Icon(
    //               Icons.logout,
    //               color: Colors.black,
    //             ),
    //             onPressed: _user == null ? null : logout,
    //           ),
    //         ],
    //         flexibleSpace: FlexibleSpaceBar(
    //             title: Text(
    //               'Nachrichten',
    //               style: GoogleFonts.inter(
    //                 fontSize: 24,
    //                 fontWeight: FontWeight.w800,
    //                 letterSpacing: -0.5,
    //                 color: Color.fromARGB(255, 22, 22, 22),
    //               ),
    //             ),
    //             titlePadding: EdgeInsets.only(left: 15, bottom: 15)),
    //       ),
    //       SliverFillRemaining(
    //         child: _user == null
    //             ? NotAuth()
    //             : StreamBuilder<List<types.Room>>(
    //                 stream: FirebaseChatCore.instance.rooms(),
    //                 initialData: const [],
    //                 builder: (context, snapshot) {
    //                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //                     return Container(
    //                       alignment: Alignment.center,
    //                       margin: const EdgeInsets.only(
    //                         bottom: 200,
    //                       ),
    //                       child: const Text('No rooms'),
    //                     );
    //                   }

    //                   return ListView.builder(
    //                     itemCount: snapshot.data!.length,
    //                     itemBuilder: (context, index) {
    //                       final room = snapshot.data![index];

    //                       return GestureDetector(
    //                         onTap: () {
    //                           Navigator.of(context).push(
    //                             MaterialPageRoute(
    //                               builder: (context) => ChatPage(
    //                                 room: room,
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                         child: Container(
    //                           padding: const EdgeInsets.symmetric(
    //                             horizontal: 16,
    //                             vertical: 8,
    //                           ),
    //                           child: Row(
    //                             children: [
    //                               _buildAvatar(room),
    //                               Text(room.name ?? ''),
    //                             ],
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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

class NotAuth extends StatelessWidget {
  const NotAuth({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        bottom: 200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Not authenticated'),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
