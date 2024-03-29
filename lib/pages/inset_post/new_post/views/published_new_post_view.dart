import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../new_post_controller.dart';
import '../widgets/back_outlined_button.dart';
import '../widgets/circle_step.dart';
import '../widgets/next_elevated_button.dart';
import '../widgets/progress_line.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class PublishedNewPostView extends StatelessWidget {
  const PublishedNewPostView({Key? key, required this.controller})
      : super(key: key);

  final NewPostController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.createPost,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        // color: Theme.of(context).colorScheme.onSecondaryContainer,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    CircleStep(3, AppLocalizations.of(context)!.step1, () {
                      controller.jumpBack();
                    }),
                    const ProgressLine(
                      isFinished: true,
                    ),
                    CircleStep(3, AppLocalizations.of(context)!.step2, () {}),
                    const ProgressLine(
                      isFinished: true,
                    ),
                    CircleStep(3, AppLocalizations.of(context)!.step3, () {}),
                  ],
                ),
                const SizedBox(height: 28),
                //tile small Wähle deien Kategorie
                Text(
                  AppLocalizations.of(context)!.finish,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                //tile small Schritt 1 von 3
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.step3of3,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      // fontSize: 18,
                      // fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                const SizedBox(height: 28),

                Expanded(
                  // color: Colors.red,
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/success.json',
                      height: //media query
                          MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                      repeat: false,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.successfullyPublished,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          // color: Theme.of(context).secondaryHeaderColor,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.postPublished,
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
                label: AppLocalizations.of(context)!.editPost,
                onPress: () => controller.pushEditPostView(),
              ),
              const SizedBox(height: 5),
              NextElevatedButton(
                onPressed: //controller.addPost() and go to
                    () => controller.jumpBackToStartPage(),
                controller: controller,
                icon: Icons.add,
                label: AppLocalizations.of(context)!.newPost,
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
