import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/logic/data_access.dart';
import 'package:locoo/logic/models/post.dart';

import 'package:locoo/pages/feed/post/post.dart' as widget;
import 'package:locoo/logic/models/post.dart' as models;
import 'package:locoo/logic/models/user.dart' as models;

// Text(
//                 'Settings',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               SizedBox(height: 20),

// create a settings Page which have a list of rounded containers with a text and a icon on the left side with scaffold

class OwnPostsView extends StatelessWidget {
  const OwnPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataAccess = Get.find<DataAccess>();

    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle:
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                    // fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    // letterSpacing: -0.5,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
          // navLargeTitleTextStyle: GoogleFonts.inter(
          //   fontSize: 30,
          //   fontWeight: FontWeight.w800,
          //   letterSpacing: -0.5,
          //   color: Theme.of(context).colorScheme.onSecondaryContainer,
          //   // color: Colors.black,
          // ),
          navLargeTitleTextStyle:
              Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // fontFamily: 'Inter',
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
        ),
        barBackgroundColor: Theme.of(context).colorScheme.background,
      ),
      child: Scaffold(
        backgroundColor:
            // Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
            Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          // A list of sliver widgets.
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              // padding: EdgeInsetsDirectional.only(
              //   start: 7,
              //   end: 23,
              // ),

              // leading: Icon(CupertinoIcons.person_2),
              // This title is visible in both collapsed and expanded states.
              // When the "middle" parameter is omitted, the widget provided
              // in the "largeTitle" parameter is used instead in the collapsed state.
              largeTitle: Text(
                'Deine Posts',
              ),
              leading: Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 0.1,
                  icon: Icon(
                    FlutterRemix.arrow_left_line,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              // padding left 10
              padding: EdgeInsetsDirectional.only(
                start: 12,
                end: 10,
              ),

              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // add a Silverlist with SettingsCard
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Expanded(
                    child: StreamBuilder<List<models.Post>>(
                      stream: dataAccess.getPostsOfUser(
                          FirebaseAuth.instance.currentUser!.uid),
                      builder: ((context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong: ${snapshot.error.toString()}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w300));
                        } else if (snapshot.hasData) {
                          final posts = snapshot.data!;

                          if (posts.isEmpty) {
                            return Center(
                              child: Column(
                                //center
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  // add a forum icon
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                  ),

                                  Icon(
                                    Icons.article_outlined,
                                    size: 100,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.1),
                                  ),
                                  Text(
                                    'Du hast noch keine Posts erstellt',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.15),
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final post = posts.elementAt(index);

                              return FutureBuilder<models.User?>(
                                future: dataAccess.getUser(post.user),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    final user = snapshot.data!;
                                    return widget.Post(
                                      post: post,
                                      postAuthorName:
                                          '${user.firstName} ${user.lastName}',
                                      postAuthorImage: user.imageUrl!,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 3),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                          // return const Text('There are no posts in the moment',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
                        }
                      }),
                    ),
                  ),
                ].toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
