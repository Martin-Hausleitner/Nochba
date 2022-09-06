//import material

import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:flutter_remix/flutter_remix.dart';

import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/data_access.dart';
import 'package:locoo/pages/chats/chat.dart';

import 'package:flutter/material.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';

import 'package:locoo/models/post.dart' as models;

import '../widgets/action_bar.dart';
import '../widgets/category_badge.dart';
import '../widgets/hashtag_badges.dart';
import '../widgets/post_profile.dart';

const startColor = Colors.black;
const targetColor = Colors.white;

const startIconColor = Colors.white;
const targetIconColor = Colors.black;

class PostView extends StatefulWidget {
  final String postAuthorImage;
  final String postAuthorName;

  final models.Post post;
  CategoryOptions category = CategoryOptions.None;
  PostView(
      {Key? key,
      required this.postAuthorImage,
      required this.postAuthorName,
      required this.post})
      : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        //disable scroll bar

        controller: scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).backgroundColor,
            // if widget.post.imageUrl is null

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.post.imageUrl,
                // post.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            pinned: true,
            expandedHeight: 200,
            leading: IconButton(
              splashRadius: 0.0001,
              icon: Icon(
                Icons.arrow_back_outlined,
                color: iconColor,
                shadows: [
                  BoxShadow(
                    color: appBarColor.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  splashRadius: 0.0001,

                  icon: Icon(
                    FlutterRemix.more_line,
                    color: iconColor,
                    shadows: [
                      BoxShadow(
                        color: appBarColor.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  //onPress open SettingsPage
                  onPressed: () {
                    //opne snackbar
                    Get.snackbar(
                      "Settings",
                      "This is a snackbar",
                    );
                  },
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.post.title,
                              //chnage the space between the words
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
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
                              category: widget.category,
                            ),

                            // Hashtag Badges
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    HashtagBadges(hashtags: widget.post.tags),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: spacingBetween),

                        // Post Profile
                        PostProfile(
                          authorImage: widget.postAuthorImage,
                          authorName: widget.postAuthorName,
                          publishDate: '---',
                          distance: '---',
                        ),

                        const SizedBox(height: spacingBetween),

                        // Discription(postDescription: widget.post.description),

                        //when the catogory is Suche the button2 is visible

                        // place a dark green button with a text "anschreiben" and a comment icon on the left side of the button

                        // Post Image

                        // Button
                        if (widget.category == CategoryModul.search ||
                            CategoryModul.subCategoriesOfSearch
                                .contains(widget.category) ||
                            widget.category == CategoryModul.lending ||
                            CategoryModul.subCategoriesOfLending
                                .contains(widget.category))
                          Padding(
                            padding: EdgeInsets.only(top: spacingBetween),
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
                // const SizedBox(height: 5000),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class PostView extends StatelessWidget {
//   //final String postTitle;
//   //final CategoryOptions postCategory;
//   //final List<String> postHashtags;
//   final String postAuthorImage;
//   final String postAuthorName;
//   //final String postPublishDate;

//   //final String postDistance;
//   //final String postImage;
//   //final String postDescription;
//   //final int postLikes;

//   /*const PostView({
//     Key? key,
//     required this.postTitle,
//     this.postCategory = CategoryOptions.Search,
//     this.postHashtags = const [
//       'test1',
//       'test2',
//       'test3',
//       'test4',
//       'test5',
//       'test6',
//     ],
//     this.postAuthorImage = 'https://i.pravatar.cc/340',
//     this.postAuthorName =
//         'ffffgggggggklljdsffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdsfj',
//     this.postPublishDate = '3',
//     this.postDistance = '300',
//     this.postImage = '',
//     this.postDescription =
//         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//     this.postLikes = 0,
//   }) : super(key: key);*/

//   final models.Post post;
//   CategoryOptions category = CategoryOptions.None;
//   PostView({
//     Key? key,
//     required this.post,
//     required this.postAuthorImage,
//     required this.postAuthorName,
//   }) : super(key: key) {
//     category = CategoryModul.getCategoryOptionByName(post.category);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             elevation: 0,
//             backgroundColor: Theme.of(context).backgroundColor,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(
//                 post.imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             pinned: true,
//             expandedHeight: MediaQuery.of(context).size.height * 0.4,
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_outlined,
//                 color: Theme.of(context).primaryColor,
//               ),
//               onPressed: () {
//                 Get.back();
//               },
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 // red container balck border 700 height 100 width 100
//                 Container(
//                   color: Colors.red,
//                   height: 1000,
//                   width: 100,
//                   child: Text(post.title),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //   @override
// //   Widget build(BuildContext context) {
// //     const double spacingBetween = 15;
// //     final dataaccess = Get.find<DataAccess>();

// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //         ),
// //         //create two text children
// //         child: Column(
// //           //allign left
// //           children: <Widget>[
// //             // Post Image
// //             post.imageUrl != ''
// //                 ? Padding(
// //                     padding: const EdgeInsets.only(top: spacingBetween),
// //                     child: Container(
// //                       height: 200,
// //                       width: double.infinity,
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(22),
// //                         child: Image.network(
// //                           post.imageUrl,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                 : Container(),

// //             // Post title
// //             Padding(
// //               padding: const EdgeInsets.only(top: 18, left: 16, right: 16),
// //               child: Column(
// //                 children: [
// //                   Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text(post.title,
// //                         //chnage the space between the words
// //                         maxLines: 3,
// //                         overflow: TextOverflow.ellipsis,
// //                         style:
// //                             Theme.of(context).textTheme.headlineSmall?.copyWith(
// //                                   fontWeight: FontWeight.bold,
// //                                   letterSpacing: -0.5,
// //                                 )),
// //                   ),

// //                   const SizedBox(height: spacingBetween),

// //                   // Badges
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     children: <Widget>[
// //                       // Category Badge
// //                       CategoryBadge(
// //                         category: category,
// //                       ),

// //                       // Hashtag Badges
// //                       Expanded(
// //                         child: SingleChildScrollView(
// //                           scrollDirection: Axis.horizontal,
// //                           padding: const EdgeInsets.only(left: 6),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.start,
// //                             children: [
// //                               HashtagBadges(hashtags: post.tags),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(height: spacingBetween),

// //                   // Post Profile
// //                   PostProfile(
// //                     authorImage: postAuthorImage,
// //                     authorName: postAuthorName,
// //                     publishDate: '---',
// //                     distance: '---',
// //                   ),

// //                   const SizedBox(height: spacingBetween),

// //                   // show a more button if the maxLines is over 4
// //                   // ExpandableText(
// //                   //   postDescription,
// //                   //   expandText: 'more',
// //                   //   collapseText: 'show less',
// //                   //   maxLines: 4,
// //                   //   linkColor: Colors.red,
// //                   //   expandOnTextTap: false,
// //                   //   urlStyle: const TextStyle(
// //                   //     color: Colors.red,
// //                   //     decoration: TextDecoration.underline,
// //                   //   ),
// //                   //   mentionStyle: const TextStyle(
// //                   //     color: Colors.green,
// //                   //     decoration: TextDecoration.underline,
// //                   //   ),
// //                   //   hashtagStyle: const TextStyle(
// //                   //     color: Colors.orange

// //                   //   ),
// //                   //   onExpandedChanged:
// //                   //   // show snakbar
// //                   //   (bool expanded) {
// //                   //     if (expanded) {
// //                   //       Scaffold.of(context).showSnackBar(
// //                   //         const SnackBar(
// //                   //           content: Text('Expanded'),
// //                   //         ),
// //                   //       );
// //                   //     } else {
// //                   //       Scaffold.of(context).showSnackBar(
// //                   //         const SnackBar(
// //                   //           content: Text('Collapsed'),
// //                   //         ),
// //                   //       );
// //                   //     }
// //                   //   },

// //                   // ),

// //                   //Create a Layoutbuilder which shows display postDiscription and when the postDescription is longer than 4 lines, show a more button

// //                   Text(
// //                     //print postDescription.split('\n').length as string
// //                     post.description,

// //                     style: Theme.of(context).textTheme.bodyMedium,
// //                   ),

// //                   //when the catogory is Suche the button2 is visible

// //                   // place a dark green button with a text "anschreiben" and a comment icon on the left side of the button

// //                   // Button
// //                   if (category == CategoryModul.search ||
// //                       CategoryModul.subCategoriesOfSearch.contains(category) ||
// //                       category == CategoryModul.lending ||
// //                       CategoryModul.subCategoriesOfLending.contains(category))
// //                     Padding(
// //                       padding: EdgeInsets.only(top: spacingBetween),
// //                       child: LocooTextButton(
// //                         icon: FlutterRemix.account_box_fill,
// //                         label: 'Anschreiben',
// //                         //onpres open Get.Snackbar
// //                         onPressed: () async {
// //                           final navigator = Navigator.of(context);
// //                           final userId = post.user;
// //                           final thisUser = await dataaccess.getChatUser(userId);
// //                           final room = await FirebaseChatCore.instance
// //                               .createRoom(thisUser!);

// //                           navigator.pop();
// //                           await navigator.push(
// //                             MaterialPageRoute(
// //                               builder: (context) => ChatPage(
// //                                 room: room,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),

// //                   const SizedBox(height: spacingBetween),

// //                   // Action Bar
// //                   // const ActionBar(),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
