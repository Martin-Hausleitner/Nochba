import 'package:flutter/material.dart';

// import '../pages/private_profile/small_post/small_post.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/data_access.dart';
import 'package:locoo/pages/feed/post/post.dart';
import 'package:locoo/models/post.dart' as models;
import 'package:locoo/models/user.dart' as models;

import 'package:locoo/pages/feed/feed_controller.dart';

import 'user_info.dart';

//import feed Controller

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataAccess = Get.find<DataAccess>();

    return Expanded(
      // width: width,
      // height: height,
      child: ContainedTabBarView(
        tabs: [
          Text(
            'Info',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text('Posts', style: Theme.of(context).textTheme.titleMedium),
        ],
        tabBarProperties: TabBarProperties(
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 4.0,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[400],
        ),
        views: [
          UserInfo(),
          // create a container with a list of post.dart
          Container(
            color: Color.fromARGB(146, 238, 238, 238),
            child: ListView(children: [
              SizedBox(height: 6),
              Container(
                child: StreamBuilder<List<models.Post>>(
                  stream: dataAccess.getPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          'Something went wrong: ${snapshot.error.toString()}',
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
                                  postAuthorName:
                                      '${user.firstName} ${user.lastName}',
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
            ]),
          ),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}
