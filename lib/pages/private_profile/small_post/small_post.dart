//import material

import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/pages/feed/post/post_view.dart';
import 'package:locoo/shared/button.dart';

import 'package:locoo/shared/round_icon_button.dart';
import 'package:flutter/material.dart';

import '../../feed/post/action_bar.dart';
import '../../feed/post/category_badge.dart';
import '../../feed/post/hashtag_badges.dart';
import '../../feed/post/post_profile.dart';

//create a new class called Post which extends StatelessWidget which is Container with infinty and a decortion box with borderradius

class SmallPost extends StatelessWidget {
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

  const SmallPost({
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
    const double spacingBetween = 5;

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
          child: Row(
            children: [
              //insert a picture 1:1 witj rounded cornders
              Expanded(
                flex: 2,
                child: Column(
                  // align left top
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PostTitle(postTitle: postTitle),

                    const SizedBox(height: spacingBetween),

                    // Badges
                    CategoryTags(
                        postCategory: postCategory, postHashtags: postHashtags),

                    const SizedBox(height: spacingBetween),

                    // Post Profile
                    TimeDistance(
                        postPublishDate: postPublishDate,
                        postDistance: postDistance),

                    const SizedBox(height: spacingBetween),

                    Discription(postDescription: postDescription),
                  ],
                ),
              ),
              // wenn postimage ist not emty
              if (postImage != '')
                Expanded(
                  child: Padding(
                    padding:
                        //left padding 5
                        const EdgeInsets.only(left: 8),
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.network(
                          'https://picsum.photos/250?image=9',
                          // height: 100,
                          // width: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  //   child: FittedBox(
                  // child: Image.network(
                  //   'https://picsum.photos/500?image=9',
                  // ),
                  // fit: BoxFit.fill,
                  // ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTags extends StatelessWidget {
  const CategoryTags({
    Key? key,
    required this.postCategory,
    required this.postHashtags,
  }) : super(key: key);

  final Category postCategory;
  final List<String> postHashtags;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            padding: const EdgeInsets.only(
              left: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HashtagBadges(hashtags: postHashtags),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PostTitle extends StatelessWidget {
  const PostTitle({
    Key? key,
    required this.postTitle,
  }) : super(key: key);

  final String postTitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(postTitle,
          //chnage the space between the words
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              )),
    );
  }
}

class TimeDistance extends StatelessWidget {
  const TimeDistance({
    Key? key,
    required this.postPublishDate,
    required this.postDistance,
  }) : super(key: key);

  final String postPublishDate;
  final String postDistance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // show a small clock icon
        const Icon(
          FlutterRemix.time_line,
          size: 12,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: [
              Text(
                postPublishDate,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // add light gray color
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'min',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // add light gray color
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        //show a locaiton icon
        const Padding(
          padding: EdgeInsets.only(left: 8),
          // show this svg:
          child: Icon(
            FlutterRemix.map_pin_line,
            size: 12,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: [
              Text(
                postDistance,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // add light gray color
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'm',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // add light gray color
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Discription extends StatelessWidget {
  const Discription({
    Key? key,
    required this.postDescription,
  }) : super(key: key);

  final String postDescription;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(1, 1),
      children: [
        //align text left
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            //print postDescription.split('\n').length as string
            postDescription,

            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7),
                  letterSpacing: -0.1,
                ),
          ),
        ),
      ],
    );
  }
}
