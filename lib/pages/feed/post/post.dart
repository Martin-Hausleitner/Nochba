//import material

import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/post.dart' as models;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/pages/feed/post/views/post_view.dart';
import 'package:locoo/pages/feed/post/widgets/action_bar.dart';
import 'package:locoo/pages/feed/post/widgets/category_badge.dart';
import 'package:locoo/pages/feed/post/widgets/discription.dart';
import 'package:locoo/pages/feed/post/widgets/hashtag_badges.dart';
import 'package:locoo/pages/feed/post/widgets/post_profile.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';

//create a new class called Post which extends StatelessWidget which is Container with infinty and a decortion box with borderradius

class Post extends StatelessWidget {
  final String postAuthorImage;
  final String postAuthorName;

  final models.Post post;
  CategoryOptions category = CategoryOptions.None;
  Post({
    Key? key,
    required this.post,
    required this.postAuthorImage,
    required this.postAuthorName,
  }) : super(key: key) {
    category = CategoryModul.getCategoryOptionByName(post.category);
  }

  // set the default value for postTitle

  @override
  Widget build(BuildContext context) {
    const double spacingBetween = 13;

    return GestureDetector(
      //onTap open postz view
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostView(
              post: post,
              postAuthorName: postAuthorName,
              postAuthorImage: postAuthorImage,
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Theme.of(context).colorScheme.onPrimary,
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
                child: Text(post.title,
                    //chnage the space between the words
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        )),
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

              Discription(postDescription: post.description),

              //when the catogory is Suche the button2 is visible

              // place a dark green button with a text "anschreiben" and a comment icon on the left side of the button

              // Post Image
              post.imageUrl != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: spacingBetween),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Hero(
                            tag: post.id,
                            child: Image.network(
                              post.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),

              // Button
              if (category == CategoryModul.search ||
                  CategoryModul.subCategoriesOfSearch.contains(category) ||
                  category == CategoryModul.lending ||
                  CategoryModul.subCategoriesOfLending.contains(category))
                Padding(
                  padding: EdgeInsets.only(top: spacingBetween),
                  child: LocooTextButton(
                    label: 'Anschreiben',
                    height: 48,
                    icon: FlutterRemix.chat_1_fill, //onpres open Get.Snackbar
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
              ActionBar(
                post: post,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
