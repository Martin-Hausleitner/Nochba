//import material

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nochba/logic/commonbase/util.dart';
import 'package:nochba/logic/data_access.dart';
import 'package:nochba/logic/flutter_firebase_chat_core-1.6.3/src/firebase_chat_core.dart';
import 'package:nochba/logic/models/Notification.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/post.dart' as models;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nochba/pages/chats/chat.dart';
import 'package:nochba/pages/feed/feed_controller.dart';
import 'package:nochba/pages/feed/views/post_view.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar.dart';
import 'package:nochba/pages/feed/widgets/post/post_profile.dart';
import 'package:nochba/pages/feed/widgets/post_card_controller.dart';

import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';

import 'post/category_badge.dart';
import 'post/discription.dart';
import 'post/hashtag_badges.dart';

//create a new class called Post which extends StatelessWidget which is Container with infinty and a decortion box with borderradius

class Post extends GetView<PostCardController> {
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
                post: post,
                authorImage: postAuthorImage,
                authorName: postAuthorName,
                publishDate: getTimeAgo(post.createdAt.toDate()),
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
              if (controller.shouldShowWriteToButton(post.uid, category))
                Padding(
                  padding: EdgeInsets.only(top: spacingBetween),
                  child: LocooTextButton(
                    label: 'Anschreiben',

                    borderRadius: 100,
                    height: 48,
                    icon: FlutterRemix.chat_1_fill, //onpres open Get.Snackbar
                    onPressed: () async =>
                        await controller.sendNotification(post.uid, post.id),
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
