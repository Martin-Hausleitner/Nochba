import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_post_controller.dart';

class NewPostPage extends GetView<NewPostController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "new post",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
