//import material

import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/commonbase/util.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
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
  final models.Post post;
  CategoryOptions category = CategoryOptions.None;
  Post({Key? key, required this.post}) : super(key: key) {
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
            builder: (context) => PostView(post: post),
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
              Row(
                children: [
                  DateDisplay(
                    date: DateTime.now(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(post.title,
                            //chnage the space between the words
                            // textAlign: TextAlign.top,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                )),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: spacingBetween),

              // Badges
              Row(
                // horizontal start
                crossAxisAlignment: CrossAxisAlignment.start,

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

              FutureBuilder<String>(
                future: controller.getDistanceToUser(post.id),
                builder: (context, snapshot) {
                  String distance = '---';
                  if (snapshot.hasData) {
                    distance = snapshot.data!;
                  }

                  return PostProfile(
                      post: post,
                      publishDate: getTimeAgo(post.createdAt.toDate()),
                      distance: distance);
                },
              ),

              const SizedBox(height: spacingBetween),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FlutterRemix.calendar_line,
                              color: Colors.grey[400],
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            // Text('${DateTime.now().toString()}'),
                            //format format like: 10. Februar 2021
                            Text(DateFormat('d. MMMM yyyy')
                                .format(post.createdAt.toDate())),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              FlutterRemix.time_line,
                              color: Colors.grey[400],
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('09:00 - 10:00'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              FlutterRemix.map_pin_line,
                              color: Colors.grey[400],
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('San Francisco'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: spacingBetween),

              Discription(postDescription: post.description),

              //when the catogory is Suche the button2 is visible

              // place a dark green button with a text "anschreiben" and a comment icon on the left side of the button

              // Post Image
              post.imageUrl != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: spacingBetween),
                      child: SizedBox(
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
                  padding: const EdgeInsets.only(top: spacingBetween),
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

class DateDisplay extends StatelessWidget {
  final DateTime date;

  const DateDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var weekStart = now.subtract(Duration(days: now.weekday - 1));
    var weekEnd = weekStart.add(const Duration(days: 7));

    String display;
    if (date.isAfter(weekStart) && date.isBefore(weekEnd)) {
      display = DateFormat('EEE').format(date);
    } else {
      display = DateFormat('MMM').format(date);
    }

    return Padding(
      padding: //left 18
          const EdgeInsets.only(right: 12),
      child: Container(
        width: 56,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: // c6c6ca
              Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                //display the month with 3 letters as a string
                display,
                style: TextStyle(
                  fontSize: 12,
                  // fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date.day.toString(),
                // "12",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // show only when the year is not the current year
              if (date.year != DateTime.now().year)
                Padding(
                  padding: //top 3
                      const EdgeInsets.only(top: 3),
                  child: Text(
                    date.year.toString(),
                    style: TextStyle(
                      // fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
