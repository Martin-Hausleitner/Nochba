// create A PostProfile class which extends StatelessWidget which is a Row with children Container and Column with 2 text

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';
import 'package:nochba/views/public_profile/public_profile_view.dart';

class PostProfile extends StatelessWidget {
  final Post post;
  final String publishDate;
  final String distance;

  const PostProfile({
    Key? key,
    required this.post,
    this.publishDate = '---',
    this.distance = '---',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // create a on tap which open public profile page
      onTap: () {
        Get.to(PublicProfileView(userId: post.uid));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LocooCircleAvatar(
            imageUrl: post.userImageUrl,
            radius: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      post.userName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                    ),
                  ),
                  TimesuburbDistance(
                    publishDate: publishDate,
                    distance: distance,
                    suburb: post.suburb,
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

class TimesuburbDistance extends StatelessWidget {
  const TimesuburbDistance({
    Key? key,
    required this.publishDate,
    required this.distance,
    required this.suburb,
  }) : super(key: key);

  final String publishDate;
  final String distance;
  final String suburb;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //vertical scroll
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // show a small clock icon
          Icon(
            FlutterRemix.time_line,
            size: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
          ),
    
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Row(
              children: [
                Text(
                  publishDate,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    // add light gray color
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
                
              ],
            ),
          ),
        
          const SizedBox(
            width: 8,
          ),
          Row(
            //center
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FlutterRemix.map_pin_line,
                size: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.5),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                suburb,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.5),
                    ),
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          SvgPicture.asset(
            'assets/icons/housing_distance.svg',
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.44),
            height: 14,
            semanticsLabel: 'A red up arrow',
          ),
    
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Row(
              children: [
                Text(
                  distance,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    // add light gray color
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
                // Text(
                //   'm',
                //   style: GoogleFonts.inter(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w400,
                //     // add light gray color
                //     color:
                //         Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
