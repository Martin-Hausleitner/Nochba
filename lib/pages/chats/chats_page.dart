import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chats_controller.dart';

class ChatsPage extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "chats",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
