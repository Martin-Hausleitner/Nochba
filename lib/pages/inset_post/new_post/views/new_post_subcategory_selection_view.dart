import 'package:flutter/material.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
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
                    CircleStep(1, AppLocalizations.of(context)!.step1, () {
                      controller.jumpBack();
                    }),
                    const ProgressLineHalf(
                      isFinished: false,
                    ),
                    CircleStep(2, AppLocalizations.of(context)!.step2, () {}),
                    const ProgressLine(
                      isFinished: false,
                    ),
                    CircleStep(2, AppLocalizations.of(context)!.step3, () {}),
                  ],
                ),
                const SizedBox(height: 28),
                //tile small Wähle deien Kategorie
                Text(
                  AppLocalizations.of(context)!.chooseCategory,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                //tile small Schritt 1 von 3
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.step1of3,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      // fontSize: 18,
                      // fontWeight: FontWeight.w600,
                      // color: Theme.of(context).secondaryHeaderColor,
                      ),
                ),
                const SizedBox(height: 28),
                /*Obx(
                  () => Expanded(
                    child: ListView.separated(
                      itemCount: controller.subcategoriesForDisplay.length,
                      itemBuilder: (BuildContext context, int index) {
                        final categories = controller.subcategoriesForDisplay;
                        // return ActionCard(
                        //     title: categories[index].name.toString(),
                        //     icon: Icon(
                        //       Icons.close_rounded_outlined,
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
                          title: AppLocalizations.of(context)!.questionKategory,
                          onTap: () => controller
                              .updateSubcategory(CategoryOptions.Question),
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.complaintKategory,
                          onTap: () => controller
                              .updateSubcategory(CategoryOptions.Appeal),
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.warningKategory,
                          onTap: () => controller
                              .updateSubcategory(CategoryOptions.Warning),
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.recommendationKategory,
                          onTap: () => controller.updateSubcategory(
                              CategoryOptions.Recommendation),
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.foundKategory,
                          onTap: () => controller
                              .updateSubcategory(CategoryOptions.Found),
                        ),
                      ],
                    ),
                  ),

                if (controller.category == CategoryOptions.Search)
                  Expanded(
                    child: Column(
                      children: [
                        ActionCard(
                          title: AppLocalizations.of(context)!.helpKategory,
                          onTap: () => controller
                              .updateSubcategory(CategoryOptions.Help),
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.lostKategory,
                          onTap: () => controller
                              .updateSubcategory(CategoryOptions.Lost),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BackOutlinedButton(
            controller: controller,
            icon: Icons.chevron_left_rounded,
            label: AppLocalizations.of(context)!.back,
            onPress: () => controller.jumpBack(),
          ),
        ),
      ],
    );
  }
}
