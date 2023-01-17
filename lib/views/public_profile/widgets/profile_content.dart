import 'package:flutter/material.dart';

// import '../pages/private_profile/small_post/small_post.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/data_access.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:nochba/logic/models/user.dart' as models;

import 'package:nochba/pages/feed/feed_controller.dart';
import 'package:nochba/pages/feed/widgets/post_card.dart';

import 'user_info.dart';

//import feed Controller

class ProfileContent extends StatelessWidget {
  final String userId;
  const ProfileContent({
    required this.userId,
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
          Container(
            //center

            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10,
            ),

            // height: 40,
            child: Text(
              'Info',
              // style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            //center

            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10,
            ),

            // height: 40,
            child: Text(
              'Posts',
              // style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
        tabBarProperties: TabBarProperties(
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 4.0,
          // padding: EdgeInsets.only(left: 18, right: 18),
          // height: 30,
          // width: 20,
          height: 50,
          alignment: TabBarAlignment.center,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          // isScrollable: true,
        ),
        views: [
          UserInfo(
            userId: userId,
          ),
          Container(
            color: Theme.of(context).colorScheme.background,
//
            child: ListView(children: [
              SizedBox(height: 6),
              Container(
                child: StreamBuilder<List<models.Post>>(
                  stream: dataAccess.getPostsOfUser(userId),
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

                          if (posts.isEmpty) {
                            return Center(
                              child: Column(
                                //center
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  // add a forum icon
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                  ),

                                  Icon(
                                    Icons.article_outlined,
                                    size: 100,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.1),
                                  ),
                                  Text(
                                    'Es sind noch keine posts vorhanden',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.15),
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Padding(
                            padding: // top 3
                                const EdgeInsets.only(top: 3),
                            child: Post(post: post),
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
