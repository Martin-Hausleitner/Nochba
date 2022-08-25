import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/data_access.dart';
import 'package:locoo/pages/feed/post/post.dart';
import 'package:locoo/models/post.dart' as models;
import 'package:locoo/models/user.dart' as models;

import '../../shared/range_slider/range_slider.dart';
import 'feed_controller.dart';

class FeedPage extends GetView<FeedController> {
  @override
  Widget build(BuildContext context) {
    final dataAccess = Get.find<DataAccess>();
    return Scaffold(
      body: Container(
        child: StreamBuilder<List<models.Post>>(
          stream: dataAccess.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong: ${snapshot.error.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w300));
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;

              return ListView.separated(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = posts.elementAt(index);

                  return FutureBuilder<models.User?>(
                    future: dataAccess.getUser(post.user),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;
                        return Post(
                          post: post,
                          postAuthorName: '${user.firstName} ${user.lastName}',
                          postAuthorImage: user.imageUrl,
                        );
                      } else {
                        return Container();
                      }
                    }),
                  );
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
      ),
    );
  }
}
