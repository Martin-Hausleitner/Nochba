import 'package:flutter/material.dart';
import 'package:locoo/shared/user_info.dart';

import '../pages/feed/post/category_badge.dart';
import '../pages/feed/post/post.dart';
// import '../pages/private_profile/small_post/small_post.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';


class ProfileContent extends StatelessWidget {
  const ProfileContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // width: width,
      // height: height,
      child: ContainedTabBarView(
        tabs: [
          Text(
            'Info',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text('Posts', style: Theme.of(context).textTheme.titleMedium),
        ],
        tabBarProperties: TabBarProperties(
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 4.0,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[400],
        ),
        views: [
          UserInfo(),
          // create a container with a list of post.dart
          Container(
            color: Color.fromARGB(146, 238, 238, 238),
            child: ListView(children: [
              SizedBox(height: 6),
              // SmallPost(
              //   postTitle: 'Post ddddddddddddTitle',
              //   postImage: 'https://i.pravatar.cc/303',
              //   // postCategory: Category.mitteilung,
              //   postAuthorName: 'John Doe',
              //   postPublishDate: '2',
              //   postDistance: '1',
              //   postDescription: 'Post Dddddescrisssption',
              // ),
              // SizedBox(height: 3),
              // SmallPost(
              //   postTitle: 'Post Title',
              //   postImage: 'https://i.pravatar.cc/303',
              //   postAuthorName: 'John Doe',
              //   postPublishDate: '2',
              //   postDistance: '1',
              //   postDescription:
              //       'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
              // ),
              // SizedBox(height: 3),
              // SmallPost(
              //   postTitle:
              //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              //   postImage: 'https://i.pravatar.cc/303',
              //   postAuthorName: 'John Doe',
              //   postPublishDate: '2',
              //   // postCategory: Category.warnung,
              //   postDistance: '1',
              //   postDescription:
              //       'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
              // ),
            ]),
          ),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}
