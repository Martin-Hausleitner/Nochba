import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chats_controller.dart';
import 'rooms.dart';

class ChatsPage extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Firebase Chat',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const RoomsPage(),
      );
}
