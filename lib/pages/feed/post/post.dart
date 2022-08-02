//import material

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:locoo/pages/feed/post/post_view.dart';
import 'package:locoo/shared/button.dart';

import 'package:locoo/shared/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'action_bar.dart';
import 'category_badge.dart';
import 'discription.dart';
import 'hashtag_badges.dart';
import 'post_profile.dart';

//create a new class called Post which extends StatelessWidget which is Container with infinty and a decortion box with borderradius

class Post extends StatelessWidget {
  final String postTitle;
  final Category postCategory;
  final List<String> postHashtags;
  final String postAuthorImage;
  final String postAuthorName;
  final String postPublishDate;

  final String postDistance;
  final String postImage;
  final String postDescription;
  final int postLikes;

  const Post({
    Key? key,
    required this.postTitle,
    this.postCategory = Category.suche,
    this.postHashtags = const [
      'test1',
      'test2',
      'test3',
      'test4',
      'test5',
      'test6',
    ],
    this.postAuthorImage = 'https://i.pravatar.cc/340',
    this.postAuthorName =
        'ffffgggggggklljdsffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdsfj',
    this.postPublishDate = '3',
    this.postDistance = '300',
    this.postImage = '',
    this.postDescription =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    this.postLikes = 0,
  }) : super(key: key);

  // set the default value for postTitle

  @override
  Widget build(BuildContext context) {
    const double spacingBetween = 15;

    return GestureDetector(
      //onTap open postz view
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostView(
              postTitle: postTitle,
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
        ),
        //create two text children
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            //allign left
            children: <Widget>[
              // Post title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(postTitle,
                    //chnage the space between the words
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge),
              ),

              const SizedBox(height: spacingBetween),

              // Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Category Badge
                  CategoryBadge(
                    category: postCategory,
                  ),

                  // Hashtag Badges
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HashtagBadges(hashtags: postHashtags),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: spacingBetween),

              // Post Profile
              PostProfile(
                authorImage: postAuthorImage,
                authorName: postAuthorName,
                publishDate: postPublishDate,
                distance: postDistance,
              ),

              const SizedBox(height: spacingBetween),

              // show a more button if the maxLines is over 4
              // ExpandableText(
              //   postDescription,
              //   expandText: 'more',
              //   collapseText: 'show less',
              //   maxLines: 4,
              //   linkColor: Colors.red,
              //   expandOnTextTap: false,
              //   urlStyle: const TextStyle(
              //     color: Colors.red,
              //     decoration: TextDecoration.underline,
              //   ),
              //   mentionStyle: const TextStyle(
              //     color: Colors.green,
              //     decoration: TextDecoration.underline,
              //   ),
              //   hashtagStyle: const TextStyle(
              //     color: Colors.orange

              //   ),
              //   onExpandedChanged:
              //   // show snakbar
              //   (bool expanded) {
              //     if (expanded) {
              //       Scaffold.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text('Expanded'),
              //         ),
              //       );
              //     } else {
              //       Scaffold.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text('Collapsed'),
              //         ),
              //       );
              //     }
              //   },

              // ),

              //Create a Layoutbuilder which shows display postDiscription and when the postDescription is longer than 4 lines, show a more button

              Discription(postDescription: postDescription),

              //when the catogory is Suche the button2 is visible

              // place a dark green button with a text "anschreiben" and a comment icon on the left side of the button

              // Post Image
              postImage != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: spacingBetween),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.network(
                            postImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(),

              // Button
              if (postCategory == Category.suche)
                Padding(
                  padding: EdgeInsets.only(top: spacingBetween),
                  child: Button(
                    text: 'Anschreiben',
                    //onpres open Get.Snackbar
                    onPressed: () {
                      Get.snackbar(
                        'Anschreiben',
                        'Du hast den Button gedrückt',
                      );
                    },
                  ),
                ),

              const SizedBox(height: spacingBetween),

              // Action Bar
              const ActionBar(),
            ],
          ),
        ),
      ),
    );
  }
}
