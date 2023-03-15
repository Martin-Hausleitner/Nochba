import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:nochba/pages/feed/widgets/post_card.dart' as widget;
import 'package:nochba/pages/private_profile/private_profile_controller.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';

class BookmarkedPostsView extends StatelessWidget {
  const BookmarkedPostsView({Key? key, required this.controller})
      : super(key: key);

  final PrivateProfileController controller;

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      contentPadding: //zero padding
          const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      title: AppLocalizations.of(context)!.yourSavedPosts,
      onPressed: () {
        Get.back();
      },
      backgroundColor: Theme.of(context).colorScheme.background,
      children: [
        FutureBuilder<List<models.Post>>(
          future: controller.getMarkedPostsOfCurrentUser(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString(),
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
                        height: MediaQuery.of(context).size.height * 0.25,
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
                        AppLocalizations.of(context)!.youHaveNotMarkedAnyPostsYet,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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

                  return Padding(
                    padding: // top 3
                        const EdgeInsets.only(top: 3),
                    child: widget.Post(
                      post: post,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 3),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
              // return const Text('There are no posts in the moment',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
            }
          }),
        ),
      ],
    );
  }
}
