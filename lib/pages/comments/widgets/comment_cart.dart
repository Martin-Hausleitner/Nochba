import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/pages/comments/widgets/action_bar.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';
import 'package:nochba/views/public_profile/public_profile_view.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(PublicProfileView(userId: comment.uid));
      },
      child: Row(
        // start of row
        crossAxisAlignment: CrossAxisAlignment.start,
        //space between
        mainAxisSize: MainAxisSize.max,

        children: [
          LocooCircleAvatar(
            imageUrl: comment.userImageUrl,
            radius: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
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
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // Spacer(),
          ActionBar(comment: comment),
        ],
      ),
    );
  }
}
