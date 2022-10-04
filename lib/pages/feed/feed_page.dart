import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:nochba/logic/models/user.dart' as models;
import 'package:nochba/pages/feed/views/feed_post_filter_view.dart';
import 'package:nochba/pages/feed/widgets/post_card.dart';

import '../../shared/range_slider/range_slider.dart';
import 'feed_controller.dart';

class FeedPage extends GetView<FeedController> {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
          children: [
            // TestSlider(),
            // Test2(),

            // ElevatedButton(
            //   child: const Text('Filter1'),
            //   // onPressed: () {
            //   //   showModalBottomSheet<void>(
            //   //     context: context,
            //   //     builder: (BuildContext context) {
            //   //       return FeedPostFilterView();
            //   //     },
            //   //   );
            //   // },
            //
            // ),

            //Create a white container whit round corners on the corners with a coliumn inside with a text "Neues in deiner Nachchbarschaft"
            // above a wor with a search bar and a on the right a primy round button with a filter icon
            Container(
              // height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  //align start
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Neues in deiner',
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    // larger text in primery Nachbarschaft
                    Text(
                      'Nachbarschaft',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          //color Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                          // round corners
                          // height: 30,
                          // child: Container(),
                          //create a textfield with a gray background and a search icon on the left with field of height 38
                          child: SizedBox(
                            height: 38,
                            child: TextField(
                              decoration: InputDecoration(
                                //set padding 0
                                contentPadding: const EdgeInsets.all(0),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.04),
                                hintText: 'Suche',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  FlutterRemix.search_2_line,
                                  size: 22,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.9),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return FeedPostFilterView();
                              },
                            );
                          },
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              FlutterRemix.filter_3_line,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    //Create a SingleChildScrollView with a row  of chips which can be selected. when seclected the color of the chip changes to primery
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            //height 38
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              'Alle',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          SizedBox(width: 06),
                          CategorieChip(
                            categorie: 'Mitteilungen',
                          ),
                          SizedBox(width: 06),
                          CategorieChip(
                            categorie: 'Suche',
                          ),
                          SizedBox(width: 06),
                          CategorieChip(
                            categorie: 'Event',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder<List<models.Post>>(
                stream: controller.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('The feeds are not available at the moment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w300)));
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!;

                    return ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts.elementAt(index);

                        return FutureBuilder<models.User?>(
                          future: controller.getUser(post.user),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              final user = snapshot.data!;
                              return Padding(
                                padding: // top 3
                                    const EdgeInsets.only(top: 3),
                                child: Post(
                                  post: post,
                                  postAuthorName:
                                      '${user.firstName} ${user.lastName}',
                                  postAuthorImage: user.imageUrl!,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 0),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                    // return const Text('There are no posts in the moment',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//create a state class ButtonShowsOverlay with a buttom that triggers a function showOverlay

//Create a class Categorie Chip with a stateful widget that has a bool isSelected and a String categorie. when seclected it chnages to primery color

class CategorieChip extends StatefulWidget {
  final String categorie;
  const CategorieChip({Key? key, required this.categorie}) : super(key: key);

  @override
  _CategorieChipState createState() => _CategorieChipState();
}

class _CategorieChipState extends State<CategorieChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        //height 38
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          widget.categorie,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
