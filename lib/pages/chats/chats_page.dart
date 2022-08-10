import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      return Text('Error schau bei _error');
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            expandedHeight: 160.0,
            forceElevated: true,
            actions: [
              // IconButton(
              //   icon: const Icon(FlutterRemix.pencil_line),
              //   color: Colors.black,
              //   onPressed: () {
              //     Get.snackbar('dsfdsf', 'dsfdsf');
              //   },
              // ),
              IconButton(
                icon: const Icon(Icons.add,color: Colors.black),
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
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: _user == null ? null : logout,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Nachrichten',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Color.fromARGB(255, 22, 22, 22),
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 15, bottom: 15)),
          ),
          SliverFillRemaining(
            child: _user == null
                ? Container(
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
                  )
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
          ),
        ],
      ),
    );
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
