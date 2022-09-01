import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/shared/ui/cards/action_card.dart';

import '../new_post_controller.dart';
import '../widgets/back_outlined_button.dart';
import '../widgets/circle_step.dart';
import '../widgets/next_elevated_button.dart';
import '../widgets/progress_line.dart';
import 'package:lottie/lottie.dart';

class PublishedNewPostView extends GetView<NewPostController> {
  const PublishedNewPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post erstellen',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        // color: Theme.of(context).colorScheme.onSecondaryContainer,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                SizedBox(height: 28),
                Row(
                  children: [
                    CircleStep(3, '1', () {
                      controller.jumpBack();
                    }),
                    ProgressLine(
                      isFinished: true,
                    ),
                    CircleStep(3, '2', () {}),
                    ProgressLine(
                      isFinished: true,
                    ),
                    CircleStep(3, '3', () {}),
                  ],
                ),
                SizedBox(height: 28),
                //tile small Wähle deien Kategorie
                Text(
                  'Fertig',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                //tile small Schritt 1 von 3
                SizedBox(height: 2),
                Text(
                  'Schritt 3 von 3',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      // fontSize: 18,
                      // fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                SizedBox(height: 28),
                Container(
                  // color: Colors.red,
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/success.json',
                      height: 200,
                      fit: BoxFit.cover,
                      repeat: false,
                      
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Erfolgreich Veröffentlicht',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          // color: Theme.of(context).secondaryHeaderColor,
                        ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Dein Post wurde erfolgreich \nveröffentlicht',
                    //align center
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        // fontSize: 18,
                        // fontWeight: FontWeight.w600,
                        // color: Theme.of(context).secondaryHeaderColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              BackOutlinedButton(
                controller: controller,
                icon: FlutterRemix.pencil_line,
                label: "Post Bearbeiten",
              ),
              SizedBox(height: 5),
              NextElevatedButton(
                onPressed: //controller.addPost() and go to
                    () {
                  controller.addPost();
                  controller.jumpToPage(4);
                  // Get.to(PublishedNewPostView());
                },
                controller: controller,
                icon: FlutterRemix.home_2_line,
                label: 'Zurück zum Feed',
              ),
            ],
          ),
        )
      ],
    );
  }
}
//     return Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Post erstellen',
//             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: -0.5,
//                   // color: Theme.of(context).colorScheme.onSecondaryContainer,
//                   color: Theme.of(context).colorScheme.onSecondaryContainer,
//                 ),
//           ),
//           SizedBox(height: 28),
//           Row(
//             children: [
//               CircleStep(3, '1', () {
//                 controller.jumpBack();
//               }),
//               ProgressLine(
//                 isFinished: true,
//               ),
//               CircleStep(3, '2', () {}),
//               ProgressLine(
//                 isFinished: true,
//               ),
//               CircleStep(3, '3', () {}),
//             ],
//           ),
//           SizedBox(height: 28),
//           //tile small Wähle deien Kategorie
//           Text(
//             'Fertig!',
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   // color: Theme.of(context).secondaryHeaderColor,
//                 ),
//           ),
//           //tile small Schritt 1 von 3
//           SizedBox(height: 2),
//           Text(
//             'Schritt 3 von 3',
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 // fontSize: 18,
//                 // fontWeight: FontWeight.w600,
//                 // color: Theme.of(context).secondaryHeaderColor,
//                 ),
//           ),
//           SizedBox(height: 28),

//           BackOutlinedButton(
//             controller: controller,
//             icon: FlutterRemix.pencil_line,
//             label: "Post Bearbeiten",
//           ),
//           SizedBox(height: 5),
//           NextElevatedButton(
//             onPressed: //controller.addPost() and go to
//                 () {
//               controller.addPost();
//               controller.jumpToPage(4);
//               // Get.to(PublishedNewPostView());
//             },
//             controller: controller,
//             icon: FlutterRemix.home_2_line,
//             label: 'Zurück zum Feed',
//           ),
//         ],
//       ),
//     );
//   }
// }
