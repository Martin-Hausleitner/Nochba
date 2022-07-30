import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifications_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "notifications",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
