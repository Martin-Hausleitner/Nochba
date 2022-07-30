// create A PostProfile class which extends StatelessWidget which is a Row with children Container and Column with 2 text

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Row(
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
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // show a small clock icon
                    const Icon(
                      Icons.access_time,
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
                        Icons.location_on_outlined,
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
    );
  }
}
