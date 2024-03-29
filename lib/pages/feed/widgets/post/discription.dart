import 'package:flutter/material.dart';
import 'package:nochba/logic/flutter_chat_ui-1.6.4/src/chat_theme.dart';
// import 'package:simplytranslate/simplytranslate.dart';

class Discription extends StatelessWidget {
  const Discription({
    Key? key,
    required this.postDescription,
  }) : super(key: key);

  final String postDescription;

  @override
  Widget build(BuildContext context) {
    String translatedText = "";
    return Stack(
      alignment: const Alignment(1, 1),
      children: [
        // align text left
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              // TextButton(
              //   child: Text("Click to translate post", 
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith( color: colors.first, letterSpacing: -0.1)),
              //   onPressed: () async {
              //     final gt = SimplyTranslator(EngineType.google);
              //     Translation libTranslate = await gt.translateSimply(postDescription);
              //     translatedText = libTranslate.translations.text;
              //     print(translatedText);
              //   },
              // ),
              Text(
                postDescription,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                      letterSpacing: -0.1,
                    ),
              ),
              Text(
                // TRANSLATED POST
                translatedText,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                      letterSpacing: -0.1,
                    ),
              )
            ],
          ),
        ),
        // COMMENTED OUT
      ],
    );
  }
}




        // SizedBox(
        //   height: 16,
        //   child: Row(
        //     // alighn left
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Container(
        //         width: 17,
        //         //height is a s bit as the other container
        //         height: 50,

        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             colors: [
        //               Colors.white.withOpacity(0.3),
        //               Colors.white,
        //             ],
        //           ),
        //         ),
        //       ),
        //       //create a white container with a text as child
        //       Container(
        //         height: 50,
        //         padding: const EdgeInsets.only(left: 6),
        //         // create a white background
        //         decoration: const BoxDecoration(
        //           color: Colors.white,
        //         ),
        //         child: Text(
        //           'more',
        //           style: // use bodyMedium but with black color
        //               Theme.of(context).textTheme.bodyMedium?.copyWith(
        //                     color: Colors.black,
        //                     fontWeight: FontWeight.w600,
        //                   ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

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
