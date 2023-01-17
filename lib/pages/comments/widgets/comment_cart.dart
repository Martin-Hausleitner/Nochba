import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/pages/comments/comment_controller.dart';
import 'package:nochba/pages/comments/views/action_bar_more_view.dart';
import 'package:nochba/pages/comments/widgets/action_bar.dart';
import 'package:nochba/pages/comments/widgets/action_bar_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_circle_icon_button.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      // start of row
      crossAxisAlignment: CrossAxisAlignment.start,
      //space between
      mainAxisSize: MainAxisSize.max,

      children: [
        LocooCircleAvatar(
          imageUrl: comment.userImageUrl,
          radius: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          // left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.userName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.88),
                  ),
            ),
            Text(
              comment.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        Spacer(),
        ActionBar(comment: comment),
      ],
    );
    // subtitle: Text(comment.text),
  }
}
