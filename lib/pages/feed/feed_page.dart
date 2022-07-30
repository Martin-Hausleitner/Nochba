import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/feed/post/category_badge.dart';
import 'package:locoo/pages/feed/post/post.dart';

import 'feed_controller.dart';

class FeedPage extends GetView<FeedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: const [
            Post(
              postTitle: 'Post ddddddddddddTitle',
              postImage: 'https://i.pravatar.cc/303',
              postCategory: Category.mitteilung,
              postAuthorName: 'John Doe',
              postPublishDate: '2',
              postDistance: '1',
              postDescription: 'Post Dddddescrisssption',
            ),
            SizedBox(height: 3),
            Post(
              postTitle: 'Post Title',
              postImage: 'https://i.pravatar.cc/303',
              postAuthorName: 'John Doe',
              postPublishDate: '2',
              postDistance: '1',
              postDescription:
                  'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
            ),
            SizedBox(height: 3),
            Post(
              postTitle:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              postImage: 'https://i.pravatar.cc/303',
              postAuthorName: 'John Doe',
              postPublishDate: '2',
              postCategory: Category.warnung,
              postDistance: '1',
              postDescription:
                  'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
            ),
          ],
        ),
      ),
    );
  }
}
