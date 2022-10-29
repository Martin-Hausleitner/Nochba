import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';

import '../new_post_controller.dart';
import '../widgets/back_outlined_button.dart';
import '../widgets/circle_step.dart';
import '../widgets/progress_line.dart';

class NewPostSubcategorySelectionView extends StatelessWidget {
  const NewPostSubcategorySelectionView({Key? key, required this.controller})
      : super(key: key);

  final NewPostController controller;

  @override
  Widget build(BuildContext context) {
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
              CircleStep(1, '1', () {
                controller.jumpBack();
              }),
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
          /*Obx(
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
          ),*/

          if (controller.category == CategoryOptions.Message)
            Expanded(
              child: Column(
                children: [
                  ActionCard(
                    title: CategoryOptions.Question.name,
                    onTap: () =>
                        controller.updateSubcategory(CategoryOptions.Question),
                  ),
                  ActionCard(
                    title: CategoryOptions.Appeal.name,
                    onTap: () =>
                        controller.updateSubcategory(CategoryOptions.Appeal),
                  ),
                  ActionCard(
                    title: CategoryOptions.Warning.name,
                    onTap: () =>
                        controller.updateSubcategory(CategoryOptions.Warning),
                  ),
                  ActionCard(
                    title: CategoryOptions.Recommendation.name,
                    onTap: () => controller
                        .updateSubcategory(CategoryOptions.Recommendation),
                  ),
                  ActionCard(
                    title: CategoryOptions.Found.name,
                    onTap: () =>
                        controller.updateSubcategory(CategoryOptions.Found),
                  ),
                ],
              ),
            ),

          if (controller.category == CategoryOptions.Search)
            Expanded(
              child: Column(
                children: [
                  ActionCard(
                    title: CategoryOptions.Help.name,
                    onTap: () =>
                        controller.updateSubcategory(CategoryOptions.Help),
                  ),
                  ActionCard(
                    title: CategoryOptions.Lost.name,
                    onTap: () =>
                        controller.updateSubcategory(CategoryOptions.Lost),
                  ),
                ],
              ),
            ),

          BackOutlinedButton(
            controller: controller,
            icon: FlutterRemix.arrow_left_s_line,
            label: "Zurück",
          ),
        ],
      ),
    );
  }
}
