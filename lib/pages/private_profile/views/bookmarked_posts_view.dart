import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:nochba/pages/feed/widgets/post_card.dart' as widget;
import 'package:nochba/pages/private_profile/private_profile_controller.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:nochba/pages/feed/widgets/post_card.dart' as widget;
import 'package:nochba/logic/models/user.dart' as models;

class BookmarkedPostsView extends StatelessWidget {
  const BookmarkedPostsView({Key? key, required this.controller})
      : super(key: key);

  final PrivateProfileController controller;

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Gespeicherten Posts',
      onPressed: () {
        Get.back();
      },
      backgroundColor: Theme.of(context).colorScheme.background,
      children: [
        FutureBuilder<List<models.Post>>(
          future: controller.getMarkedPostsOfCurrentUser(),
          builder: ((context, snapshot) {
            //return Text('Hey');
            if (snapshot.hasError) {
              return Text('Something went wrong: ${snapshot.error.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w300));
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;

              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    //center
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // add a forum icon
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
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
                        'Du hast noch keine Posts markiert',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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

              return ListView.separated(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = posts.elementAt(index);

                  return FutureBuilder<models.User?>(
                    future: controller.getUser(post.user),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;
                        return widget.Post(
                          post: post,
                          postAuthorName: '${user.firstName} ${user.lastName}',
                          postAuthorImage: user.imageUrl!,
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
          }),
        ),
      ],
    );
  }
}
