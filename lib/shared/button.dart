import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

// create a stateless button with a text NEW and a background color of Colors.blue[100]
class Button2 extends StatelessWidget {
  final String text;

  const Button2({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //create a Container with full and a icon and a tex in the middle
    // return Container(
    //   width: double.infinity,
    //   height: 40,
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).primaryColor,
    //     borderRadius: BorderRadius.circular(14),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       // create a svg from this string "<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><path fill="none" d="M0 0h24v24H0z"/><path d="M10 3h4a8 8 0 1 1 0 16v3.5c-5-2-12-5-12-11.5a8 8 0 0 1 8-8z"/></svg>"
    //       // add a white icon FlutterRemix.chat_1_line
    //       const Icon(
    //         FlutterRemix.chat_1_fill,
    //         color: Colors.white,
    //         size: 20,
    //       ),

    //       const SizedBox(
    //         width: 10,
    //       ),
    //       Text(
    //         text,
    //         style: GoogleFonts.inter(
    //           fontSize: 14,
    //           fontWeight: FontWeight.w600,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // return TextButton.icon(
    //   //set color to primeryColor

    //   // <-- TextButton
    //   onPressed: () {},
    //   icon: const Icon(
    //     FlutterRemix.chat_1_fill,
    //     size: 24.0,
    //   ),
    //   label: Text('Download'),
    // );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              // add primeryColor to the background
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextButton.icon(
            //   //set color to primeryColor

            // <-- TextButton
            onPressed: () {},
            icon: const Icon(
              FlutterRemix.chat_1_fill,
              size: 24.0,
            ),

            label: Text('Downldddoad'),
            style: // add primeryColor to the text
                TextButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              textStyle: Theme.of(context).textTheme.button, // Foreground color

              // Background color
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
          ),
        ],
      ),
    );
  }
}
