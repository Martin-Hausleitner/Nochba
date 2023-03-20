import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/comments/comment_page.dart';
import 'package:nochba/pages/feed/views/action_bar_more/action_bar_more_view.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_circle_icon_button.dart';

import 'package:nochba/logic/models/bookmark.dart';
import 'package:nochba/logic/models/post.dart';

//create a ActionBar class which have multiple round icon Buttons
class ActionBar extends StatefulWidget {
  final Post post;

  const ActionBar({Key? key, required this.post}) : super(key: key);

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  int localLikes = 0;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActionBarController>();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder<List<String>>(
            stream: controller.getLikedPostsOfCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final likedPosts = snapshot.data!;
                isLiked = likedPosts.contains(widget.post.id);
              }
              return LocooCircleIconButton(
                icon: Icons.thumb_up,
                isPressed: isLiked,
                onPressed: () async {
                  if (isLiked) {
                    await controller.unlikePost(widget.post.id);
                    setState(() {
                      localLikes--;
                    });
                  } else {
                    await controller.likePost(widget.post.id);
                    setState(() {
                      localLikes++;
                    });
                  }
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              );
            },
          ),
          StreamBuilder<int?>(
            stream: controller.getLikesOfPost(widget.post.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                localLikes = snapshot.data!;
              }
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 18),
                child: Text(
                  '$localLikes',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),

          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
          LocooCircleIconButton(
            icon: Icons.forum,
            onPressed: () {
              Get.to(CommentPage(postId: widget.post.id));
            },
          ),
          FutureBuilder<int>(
            future: controller.getCommentCountOfPost(widget.post.id),
            builder: (context, snapshot) {
              int? data;
              if (snapshot.hasData) {
                data = snapshot.data;
              }

              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 18),
                child: Text(
                  data != null ? '$data' : '-',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
          StreamBuilder<BookMark?>(
            stream: controller.getBookMarkOfCurrentUser(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final bookMark = snapshot.data!;
                if (bookMark.posts.contains(widget.post.id)) {
                  return LocooCircleIconButton(
                      icon: Icons.bookmark,
                      isPressed: true,
                      // color: Theme.of(context).colorScheme.primary,
                      onPressed: () async => await controller.unsavePost(
                          bookMark, widget.post.id));
                } else {
                  return LocooCircleIconButton(
                      icon: Icons.bookmark,
                      isPressed: false,
                      onPressed: () async =>
                          await controller.savePost(bookMark, widget.post.id));
                }
              } else {
                return LocooCircleIconButton(
                  icon: Icons.bookmark,
                  // isPressed: true,
                  // color: Colors.grey,
                  onPressed: () {},
                );
              }
            }),
          ),

          const Spacer(),
          LocooCircleIconButton(
            icon: Icons.more_horiz,
            onPressed: () {
              showModalBottomSheet<dynamic>(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return
                      // height of the modal bottom sheet
                      ActionBarMore(
                    controller: controller,
                    post: widget.post,
                  );
                },
              );
            },
          ),

          // add a row with aliged left with a RoundIconButton

          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
        ],
      ),
    );
  }
}

//create a round container which changes color when pressed and when its pressed again it changes back to its original color

