//import material

//import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:flutter_remix/flutter_remix.dart';

import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';

import 'package:flutter/material.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar.dart';
import 'package:nochba/pages/feed/widgets/post/category_badge.dart';
import 'package:nochba/pages/feed/widgets/post/hashtag_badges.dart';
import 'package:nochba/pages/feed/widgets/post/post_profile.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';

import 'package:nochba/logic/models/post.dart' as models;

class PostView extends StatelessWidget {
  final models.Post post;
  const PostView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.imageUrl == '') {
      return PostViewNoImage(post: post);
    } else {
      return PostViewImage(post: post);
    }
  }
}

class PostViewNoImage extends StatelessWidget {
  final models.Post post;
  const PostViewNoImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    const double spacingBetween = 13;

    // return a scaffold with a appbar
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Post'),
        leading: IconButton(
          splashRadius: 0.0001,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: IconButton(
          //     splashRadius: 0.0001,

          //     icon: Icon(
          //       FlutterRemix.more_line,
          //       color: Theme.of(context).colorScheme.onBackground,
          //     ),
          //     //onPress open SettingsPage
          //     onPressed: () {
          //       //opne snackbar
          //       Get.snackbar(
          //         "Settings",
          //         "This is a snackbar",
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: Column(
                //align left
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    
                    children: [
                      Text(post.title,
                          //chnage the space between the words
                          //align the text to the left
                          textAlign: TextAlign.left,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  )),
                    ],
                  ),

                  const SizedBox(height: spacingBetween),

                  // Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Category Badge
                      // CategoryBadge(
                      //   category: post.category,
                      // ),
                      //create a wrap with a lost of HashtagBadge using the post.tags
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 3,
                          children: [
                            for (var tag in post.tags)
                              HashtagBadge(
                                hashtag: tag,
                              ),
                          ],
                        ),
                      ),

                      // Hashtag Badges
                      // Expanded(
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     padding: const EdgeInsets.only(left: 6),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         HashtagBadges(hashtags: post.tags),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: spacingBetween),

                  // Post Profile
                  PostProfile(
                    post: post,
                    publishDate: '---',
                    distance: '---',
                  ),

                  const SizedBox(height: spacingBetween),

                  Text(
                    //print postDescription.split('\n').length as string
                    post.description,
                    //align left
                    textAlign: TextAlign.left,

                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                          letterSpacing: -0.1,
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
        ],
      ),
    );
  }
}

const startColor = Colors.black;
const targetColor = Colors.white;

const startIconColor = Colors.white;
const targetIconColor = Colors.black;

class PostViewImage extends StatefulWidget {
  final models.Post post;
  CategoryOptions category = CategoryOptions.None;
  PostViewImage({Key? key, required this.post}) : super(key: key);

  @override
  _PostViewImageState createState() => _PostViewImageState();
}

class _PostViewImageState extends State<PostViewImage> {
  final scrollController = ScrollController();

  final appBarColorTween = ColorTween(begin: startColor, end: targetColor);

  final iconColorTween =
      ColorTween(begin: startIconColor, end: targetIconColor);

  double lerp = 0.0;
  Color get appBarColor => appBarColorTween.transform(lerp) ?? startColor;
  Color get iconColor => iconColorTween.transform(lerp) ?? startIconColor;

  @override
  void initState() {
    scrollController.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.initState();
  }

  void listener() {
    var offset = scrollController.offset;
    setState(() => lerp = offset < 200 ? offset / 200 : 1);
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBetween = 13;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // if widget.post.imageUrl is null then return Container else return CustomScrollView
      body: CustomScrollView(
        //disable scroll bar

        controller: scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            // if widget.post.imageUrl is null

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.post.id,
                child: Image.network(
                  widget.post.imageUrl,
                  // post.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            pinned: true,
            expandedHeight: 200,
            leading: Padding(
              padding: //left 20 top 20 bottom 20
                  const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Container(
                //reounded button
                decoration: BoxDecoration(
                  color: //color scheme colorScheme": {
                      // "background
                      Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(100),
                ),
                // padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  splashRadius: 0.0001,
                  icon: const Icon(
                    Icons.chevron_left_outlined,

                    // color: iconColor,
                    // color primery color
                    color: Colors.black,

                    // shadows: [
                    //   BoxShadow(
                    //     color: appBarColor.withOpacity(0.4),
                    //     blurRadius: 10,
                    //   ),
                    // ],
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
            actions: const [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: //color scheme colorScheme": {
              //           // "background
              //           Theme.of(context).colorScheme.background,
              //       borderRadius: BorderRadius.circular(100),
              //     ),
              //     child: IconButton(
              //       splashRadius: 0.0001,
              //       padding: const EdgeInsets.all(0),

              //       icon: Icon(
              //         Icons.more_horiz_outlined,
              //         color: Colors.black,
              //         // shadows: [
              //         //   BoxShadow(
              //         //     color: appBarColor.withOpacity(0.4),
              //         //     blurRadius: 10,
              //         //   ),
              //         // ],
              //       ),
              //       //onPress open SettingsPage
              //       onPressed: () {
              //         //opne snackbar
              //         Get.snackbar(
              //           "Settings",
              //           "This is a snackbar",
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                )),

                        const SizedBox(height: spacingBetween),
                        Wrap(
                          spacing: 6,
                          runSpacing: 3,
                          children: [
                            CategoryBadge(
                              category: widget.category,
                            ),
                            for (var tag in widget.post.tags)
                              HashtagBadge(
                                hashtag: tag,
                              ),
                          ],
                        ),

                        // Badges
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: <Widget>[
                        //     CategoryBadge(
                        //       category: widget.category,
                        //     ),

                        //     // Hashtag Badges
                        //     Expanded(
                        //       child: SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         padding: const EdgeInsets.only(left: 6),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             HashtagBadges(hashtags: widget.post.tags),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        const SizedBox(height: spacingBetween),

                        // Post Profile
                        PostProfile(
                          post: widget.post,
                          publishDate: '---',
                          distance: '---',
                        ),

                        const SizedBox(height: spacingBetween),

                        // Button
                        if (widget.category == CategoryModul.search ||
                            CategoryModul.subCategoriesOfSearch
                                .contains(widget.category) ||
                            widget.category == CategoryModul.lending ||
                            CategoryModul.subCategoriesOfLending
                                .contains(widget.category))
                          Padding(
                            padding: const EdgeInsets.only(top: spacingBetween),
                            child: LocooTextButton(
                              label: 'Anschreiben',
                              height: 48,
                              icon: FlutterRemix
                                  .chat_1_fill, //onpres open Get.Snackbar
                              onPressed: () {
                                Get.snackbar(
                                  'Anschreiben',
                                  'Du hast den Button gedrückt',
                                );
                              },
                            ),
                          ),

                        Text(
                          //print postDescription.split('\n').length as string
                          widget.post.description,

                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.7),
                                    letterSpacing: -0.1,
                                  ),
                        ),
                        const SizedBox(height: spacingBetween),

                        // Action Bar
                        ActionBar(
                          post: widget.post,
                        ),
                      ],
                    ),
                  ),
                ),
                // red container balck border 700 height 100 width 100

                //red conteienr 5000 height
                const SizedBox(height: 5000),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
