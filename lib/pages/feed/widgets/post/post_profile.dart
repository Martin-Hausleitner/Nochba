// create A PostProfile class which extends StatelessWidget which is a Row with children Container and Column with 2 text

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';
import 'package:nochba/views/public_profile/public_profile_view.dart';

class PostProfile extends StatelessWidget {
  final String authorImage;
  final String authorName;
  final String publishDate;
  final String distance;

  const PostProfile({
    Key? key,
    this.authorImage = 'https://i.pravatar.cc/303',
    this.authorName = 'John Doe',
    this.publishDate = '1',
    this.distance = '1',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // create a on tap which open public profile page
      onTap: () {
        Get.to(PublicProfileView(
            authorName: authorName, authorImage: authorImage));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LocooCircleAvatar(
            imageUrl: authorImage,
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
                      authorName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                    ),
                  ),
                  TimeDistance(publishDate: publishDate, distance: distance),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeDistance extends StatelessWidget {
  const TimeDistance({
    Key? key,
    required this.publishDate,
    required this.distance,
  }) : super(key: key);

  final String publishDate;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              /*Text(
                'min',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // add light gray color
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                ),
              ),*/
            ],
          ),
        ),
        // SizedBox(
        //   width: 8,
        // ),
        // Icon(
        //   FlutterRemix.map_pin_line,
        //   size: 12,
        //   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
        // ),

        // Padding(
        //   padding: const EdgeInsets.only(left: 2),
        //   child: Row(
        //     children: [
        //       // Text(
        //       //   publishDate,
        //       //   style: GoogleFonts.inter(
        //       //     fontSize: 12,
        //       //     fontWeight: FontWeight.w400,
        //       //     // add light gray color
        //       //     color:
        //       //         Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
        //       //   ),
        //       // ),
        //       Text(
        //         'Auwiesen',
        //         style: GoogleFonts.inter(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w400,
        //           // add light gray color
        //           color:
        //               Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //show a locaiton icon
        // Padding(
        //   padding: EdgeInsets.only(left: 8),
        //   // show this svg:
        //   child: Icon(
        //     FlutterRemix.map_pin_line,
        //     size: 12,
        //     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
        //   ),
        // ),
        //show svg housing_distance.svg
        SizedBox(
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
              Text(
                'm',
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
      ],
    );
  }
}
