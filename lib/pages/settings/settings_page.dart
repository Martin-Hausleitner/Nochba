import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/settings/settings/settings_card.dart';

import '../feed/post/category_badge.dart';
import '../feed/post/post.dart';

// create a settings Page which have a list of rounded containers with a text and a icon on the left side with scaffold

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: // add colum with a titleLarge text and a list of rounded containers with a text and a icon on the left side
          Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          // allign left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),

            Container(
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
            //create a list view
            // create a list view with a text

            // add listview with a a gray rounded container with a text and a icon on the left side
          ],
        ),
      ),
    );
  }
}
