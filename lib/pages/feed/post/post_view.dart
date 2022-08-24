//import material

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/shared/button.dart';

import 'package:locoo/shared/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'action_bar.dart';
import 'category_badge.dart';
import 'discription.dart';
import 'hashtag_badges.dart';
import 'post_profile.dart';
import 'package:locoo/models/post.dart' as models;


//create a new class called Post which extends StatelessWidget which is Container with infinty and a decortion box with borderradius

class PostView extends StatelessWidget {
  //final String postTitle;
  //final CategoryOptions postCategory;
  //final List<String> postHashtags;
  final String postAuthorImage;
  final String postAuthorName;
  //final String postPublishDate;

  //final String postDistance;
  //final String postImage;
  //final String postDescription;
  //final int postLikes;

  /*const PostView({
    Key? key,
    required this.postTitle,
    this.postCategory = CategoryOptions.Search,
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
  }) : super(key: key);*/

  final models.Post post;
  CategoryOptions category = CategoryOptions.None;
  PostView({
    Key? key,
    required this.post,
  
    required this.postAuthorImage,
    required this.postAuthorName,
  }) : super(key: key) {
    category = CategoryModul.getCategoryOptionByName(post.category);
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBetween = 15;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        //create two text children
        child: Column(
          //allign left
          children: <Widget>[
            // Post Image
            post.imageUrl != ''
                ? Padding(
                    padding: const EdgeInsets.only(top: spacingBetween),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(),

            // show a photo from unspash
            /*Image.network(
              'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
              fit: BoxFit.cover,
            ),*/

            // Post title
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 16, right: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(post.title,
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
                        category: category,
                      ),

                      // Hashtag Badges
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HashtagBadges(hashtags: post.tags),
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
                    publishDate: '---',
                    distance: '---',
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

                  Text(
                    //print postDescription.split('\n').length as string
                    post.description,

                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  //when the catogory is Suche the button2 is visible

                  // place a dark green button with a text "anschreiben" and a comment icon on the left side of the button

                  // Button
              if (category == CategoryModul.search || CategoryModul.subCategoriesOfSearch.contains(category) ||
                  category == CategoryModul.lending || CategoryModul.subCategoriesOfLending.contains(category))
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
                  // const ActionBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
