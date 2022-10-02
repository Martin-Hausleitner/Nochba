import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:nochba/logic/models/user.dart' as models;
import 'package:nochba/pages/feed/views/feed_post_filter_view.dart';
import 'package:nochba/pages/feed/widgets/post_card.dart';

import '../../shared/range_slider/range_slider.dart';
import 'feed_controller.dart';

class FeedPage extends GetView<FeedController> {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
          children: [
            // TestSlider(),
            // Test2(),

            ElevatedButton(
              child: const Text('Filter1'),
              // onPressed: () {
              //   showModalBottomSheet<void>(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return FeedPostFilterView();
              //     },
              //   );
              // },
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0))),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return FeedPostFilterView();
                  },
                );
              },
            ),

            Expanded(
              child: StreamBuilder<List<models.Post>>(
                stream: controller.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('The feeds are not available at the moment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w300)));
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!;

                    return ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts.elementAt(index);

                        return FutureBuilder<models.User?>(
                          future: controller.getUser(post.user),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              final user = snapshot.data!;
                              return Post(
                                post: post,
                                postAuthorName:
                                    '${user.firstName} ${user.lastName}',
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//create a state class ButtonShowsOverlay with a buttom that triggers a function showOverlay

