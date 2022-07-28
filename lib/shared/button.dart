import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

// create a stateless button with a text NEW and a background color of Colors.blue[100]
class Button2 extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const Button2(
      {Key? key, required this.text, this.backgroundColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //create a Container with full and a icon and a tex in the middle
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // create a svg from this string "<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><path fill="none" d="M0 0h24v24H0z"/><path d="M10 3h4a8 8 0 1 1 0 16v3.5c-5-2-12-5-12-11.5a8 8 0 0 1 8-8z"/></svg>"
          SvgPicture.asset(
            'assets/svgs/chat.svg',
            width: 20,
            height: 20,
            color: Colors.white,
          ),

          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
