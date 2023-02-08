import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/logic/models/LikedComment.dart';
import 'package:nochba/pages/comments/views/action_bar_more_view.dart';
import 'package:nochba/pages/comments/widgets/action_bar_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_circle_icon_button.dart';

class ActionBar extends GetView<CommentActionBarController> {
  final Comment comment;
  const ActionBar({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<List<LikedComment>>(
          stream: controller.getLikedCommentsOfCurrentUser(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final likedComments = snapshot.data!
                  .where((element) => element.post == comment.post);
              if (likedComments
                  .any((likedComment) => likedComment.id == comment.id)) {
                return LocooCircleIconButton(
                    icon: Icons.thumb_up,
                    isPressed: true,
                    onPressed: () async =>
                        await controller.unlikeComment(comment.id));
              } else {
                return LocooCircleIconButton(
                    icon: Icons.thumb_up,
                    isPressed: false,
                    onPressed: () async =>
                        await controller.likeComment(comment.id, comment.post));
              }
            } else {
              return LocooCircleIconButton(
                icon: Icons.thumb_up,
                // isPressed: true,
                // color: Colors.grey,
                onPressed: () {},
              );
            }
          }),
        ),
        FutureBuilder<int?>(
          future: controller.getLikesOfComment(comment.post, comment.id),
          builder: (context, snapshot) {
            int? data;
            if (snapshot.hasData) {
              data = snapshot.data;
            }

            if (data == 0) {
              return const SizedBox(
                width: 5,
                height: 0,
              );
            } else {
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
            }
          },
        ),
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
                    ActionBarMore(comment: comment, controller: controller);
              },
            );
          },
        ),
      ],
    );
  }
}
