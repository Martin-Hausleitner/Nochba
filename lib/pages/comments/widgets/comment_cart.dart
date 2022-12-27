import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/pages/comments/comment_controller.dart';
import 'package:nochba/pages/comments/views/action_bar_more_view.dart';
import 'package:nochba/pages/comments/widgets/action_bar.dart';
import 'package:nochba/pages/comments/widgets/comment_cart_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_circle_icon_button.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.comment,
    required this.commentAuthorName,
    required this.commentAuthorImage,
  }) : super(key: key);

  final Comment comment;
  final String commentAuthorImage;
  final String commentAuthorName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          LocooCircleAvatar(
            imageUrl: commentAuthorImage,
            radius: 20,
          ),
          Text(
            commentAuthorName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ActionBar(comment: comment)
        ],
      ),
      subtitle: Text(comment.text),
    );
  }
}
