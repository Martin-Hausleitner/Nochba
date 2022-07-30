import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Discription extends StatelessWidget {
  const Discription({
    Key? key,
    required this.postDescription,
  }) : super(key: key);

  final String postDescription;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(1, 1),
      children: [
        //align text left
        Align(
          alignment: Alignment.centerLeft,
          child: SelectableText(
            //print postDescription.split('\n').length as string
            postDescription,

            maxLines: 3,
            style: GoogleFonts.inter(
              //change the space bettwene the letters
              letterSpacing: -0.1,
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ),

        SizedBox(
          height: 12,
          child: Row(
            // alighn left
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 17,
                //height is a s bit as the other container
                height: 50,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white,
                    ],
                  ),
                ),
              ),
              //create a white container with a text as child
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 6),
                // create a white background
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'More',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),

        // Container(
        //   padding: const EdgeInsets.only(left: 20),
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         Color.fromARGB(144, 221, 221, 221),
        //         Colors.white,
        //         Colors.blue,
        //       ],
        //     ),
        //   ),
        //   child: const Text(
        //     'Read More',
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.w500,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
