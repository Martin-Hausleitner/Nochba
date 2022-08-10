// create A PostProfile class which extends StatelessWidget which is a Row with children Container and Column with 2 text

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../public_profile/public_profile_page.dart';

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
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(authorImage),
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Row(
                    children: [
                      // show a small clock icon
                      const Icon(
                        FlutterRemix.time_line,
                        size: 12,
                        color: Colors.grey,
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
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'min',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                // add light gray color
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //show a locaiton icon
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        // show this svg:
                        child: Icon(
                          FlutterRemix.map_pin_line,
                          size: 12,
                          color: Colors.grey,
                        ),
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
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'm',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                // add light gray color
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
