import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/shared/ui/cards/action_card.dart';

import '../new_post_controller.dart';
import '../widgets/circle_step.dart';
import '../widgets/progress_line.dart';

class NewPostSubcategorySelectionView extends GetView<NewPostController> {
  const NewPostSubcategorySelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Padding(
      padding: const EdgeInsets.all(25.0),
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
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
          SizedBox(height: 28),
          Row(
            children: [
              CircleStep(1, '1', () {}),
              ProgressLineHalf(
                isFinished: false,
              ),
              CircleStep(2, '2', () {}),
              ProgressLine(
                isFinished: false,
              ),
              CircleStep(2, '3', () {}),
            ],
          ),
          SizedBox(height: 28),
          //tile small Wähle deien Kategorie
          Text(
            'Wähle deine Kategorie',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                ),
          ),
          //tile small Schritt 1 von 3
          SizedBox(height: 2),
          Text(
            'Schritt 1 von 3',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                // fontSize: 18,
                // fontWeight: FontWeight.w600,
                // color: Theme.of(context).secondaryHeaderColor,
                ),
          ),
          SizedBox(height: 28),
          Obx(
            () => Expanded(
              child: ListView.separated(
                itemCount: controller.subcategoriesForDisplay.length,
                itemBuilder: (BuildContext context, int index) {
                  final categories = controller.subcategoriesForDisplay;
                  // return ActionCard(
                  //     title: categories[index].name.toString(),
                  //     icon: Icon(
                  //       Icons.close_outlined,
                  //     ),
                  //     onTap: controller.updateSubcategory(categories[index]));
                  return InkWell(
                    onTap: () {
                      controller.updateSubcategory(categories[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.08),
                      ),
                      child: Text(categories[index].name.toString()),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ),
          // Obx(
          //   () => ActionCard(
          //     title: 'Weiter',
          //     icon: Icon(FlutterRemix.t_box_fill),
          //     onTap: () {
          //       controller.updateSubcategory(categories[1]);
          //     },
          //   ),
          // ),
          IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                controller.jumpBack();
              })
        ],
      ),
    );
  }
}
