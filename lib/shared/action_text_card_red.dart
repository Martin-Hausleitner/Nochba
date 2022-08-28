import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

//create a class which have a rounded container with a icon on the left side and a text and on the right side a arrow icon
class ActionTextCardRed extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback onTap;
  final String text;

  const ActionTextCardRed(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 13, left: 15, right: 9, bottom: 13),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          // letterSpacing: -0.1,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    //align right

                    text,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,

                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),

                          // letterSpacing: -0.1,
                        ),
                  ),
                ),
                Icon(
                  FlutterRemix.arrow_right_s_line,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//     return Padding(
//       padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           // add background color to the rounded container
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child:

      
//               // return a rounded container with a icon on the left side and a text
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Text(
//                         title,
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               fontWeight: FontWeight.w500,
//                               // letterSpacing: -0.1,
//                             ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Text(
//                         text,
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               // fontWeight: FontWeight.w400,
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.6),
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: Icon(
//                   FlutterRemix.arrow_right_s_line,
//                   color:
//                       Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
//                 ),
//               ),
//             ],
//           ),

//         ),
//       ),
//     );
//   }
// }
