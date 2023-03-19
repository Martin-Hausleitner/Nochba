import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'new_post_controller.dart';
import 'views/new_post_subcategory_selection_view.dart';
import 'views/new_post_view.dart';
import 'views/published_new_post_view.dart';
import 'widgets/category_tile.dart';
import 'widgets/circle_step.dart';
import 'widgets/progress_line.dart';

class NewPostPage extends GetView<NewPostController> {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,

      // appBar: AppBar(
      //   title: const Text('Add a post'),
      //   backgroundColor: Theme.of(context).backgroundColor,
      //   shadowColor: Colors.transparent,
      // ),
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          NewPostCategorySelectionView(controller: controller),
          NewPostSubcategorySelectionView(controller: controller),
          NewPostView(controller: controller),
          PublishedNewPostView(controller: controller),
        ],
      ),
    );
  }
}

class NewPostCategorySelectionView extends StatelessWidget {
  const NewPostCategorySelectionView({Key? key, required this.controller})
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
            AppLocalizations.of(context)!.createPost,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  // color: Theme.of(context).colorScheme.onSecondaryContainer,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              CircleStep(1, AppLocalizations.of(context)!.step1, () {}),
              const ProgressLine(
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

          Expanded(
            child: GridView.count(
              primary: false,
              // padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                CategoryTile(
                  title: AppLocalizations.of(context)!.lendingKategory,
                  //CategoryOptions.Message.name.toString()
                  icon: FlutterRemix.hand_heart_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Lending);
                  },
                ),
                CategoryTile(
                  title: AppLocalizations.of(context)!.messageKategory,
                  icon: FlutterRemix.message_2_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Message);
                  },
                ),
                CategoryTile(
                  title: AppLocalizations.of(context)!.event,
                  icon: FlutterRemix.calendar_event_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Event);
                  },
                ),
                CategoryTile(
                  title: AppLocalizations.of(context)!.searchKategory,
                  icon: FlutterRemix.search_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Search);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






//create a progress line with a constructer isfinished when true shwo a green line when false show DottedLine(), in a Expanded widget

