import 'package:flutter/material.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nochba/logic/models/user.dart' as models;

import '../models/bubble_rtl_alignment.dart';
import '../util.dart';
import 'inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.onAvatarTap,
  });

  /// Author to show image and name initials from.
  final models.User author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// Called when user taps on an avatar.
  final void Function(models.User)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final color = getUserAvatarNameColor(
      author,
      InheritedChatTheme.of(context).theme.userAvatarNameColors,
    );
    final hasImage = author.imageUrl != null;
    final initials = getUserInitials(author);

    return Container(
      margin: bubbleRtlAlignment == BubbleRtlAlignment.left
          ? const EdgeInsetsDirectional.only(end: 8)
          : const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onAvatarTap?.call(author),
        child: CircleAvatar(
          backgroundColor: hasImage
              ? InheritedChatTheme.of(context)
                  .theme
                  .userAvatarImageBackgroundColor
              : color,
          backgroundImage: hasImage ? NetworkImage(author.imageUrl!) : null,
          radius: 16,
          child: !hasImage
              ? Text(
                  initials,
                  style:
                      InheritedChatTheme.of(context).theme.userAvatarTextStyle,
                )
              : null,
        ),
      ),
    );
  }
}
