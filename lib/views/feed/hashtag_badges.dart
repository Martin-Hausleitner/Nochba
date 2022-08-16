// create a PostBadge class with a blue badge and text 'New'

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Create a HashtagBadges class which displys a list of hashtags and can be scolled horizontally
class HashtagBadges extends StatelessWidget {
  final List<String> hashtags;

  const HashtagBadges({
    Key? key,
    this.hashtags = const ['hashtag1', 'hashtag2', 'hashtag3'],
  }) : super(key: key);

  //create a SingleChildScrollView class with a list of hashtags and with HashtagBadge a
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // physics: const BouncingScrollPhysics(),
      
      child: Row(
        children: hashtags
            .map((hashtag) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: HashtagBadge(
                    hashtag: hashtag,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class HashtagBadge extends StatelessWidget {
  final String hashtag;
  const HashtagBadge({Key? key, required this.hashtag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 207, 207, 207),
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '#$hashtag',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}

//create a stateful widget badge with contrscuter final string text
