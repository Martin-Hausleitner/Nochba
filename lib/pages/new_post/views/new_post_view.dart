import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/models/category.dart';
import 'package:locoo/pages/feed/post/widgets/filter/filter_range_slider.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';
import 'package:material_tag_editor/tag_editor.dart';

import '../new_post_controller.dart';
import '../widgets/back_outlined_button.dart';
import '../widgets/circle_step.dart';
import '../widgets/next_elevated_button.dart';
import '../widgets/progress_line.dart';
import 'published_new_post_view.dart';

class NewPostView extends StatelessWidget {
  final bool hasSubcategories;
  const NewPostView({Key? key, this.hasSubcategories = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();

    // create a listview with a fixed bottom bar
    return Column(
      // align start
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: // top 10
              const EdgeInsets.only(top: 25.0, right: 25, left: 25, bottom: 10),
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
                  CircleStep(3, '1', () {}),
                  ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(1, '2', () {}),
                  ProgressLine(
                    isFinished: false,
                  ),
                  CircleStep(2, '3', () {}),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Expanded(
                child: Padding(
                  //left right 25
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 28),
                      //tile small Wähle deien Kategorie
                      Text(
                        // show category, and if subcategory is avabile add " - " and ontroller.subcategory.name.toString()
                        controller.subcategory != CategoryOptions.None
                            ? "${controller.category.name.toString()} - ${controller.subcategory.name.toString()}"
                            : controller.category.name.toString(),

                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  // color: Theme.of(context).secondaryHeaderColor,
                                ),
                      ),
                      //tile small Schritt 1 von 3
                      SizedBox(height: 2),
                      Text(
                        'Schritt 2 von 3',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            // fontSize: 18,
                            // fontWeight: FontWeight.w600,
                            // color: Theme.of(context).secondaryHeaderColor,
                            ),
                      ),
                      SizedBox(height: 20),

                      LocooTextField(
                          controller: controller.titleController,
                          textInputAction: TextInputAction.next,
                          label: 'Titel',
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) => value != null && value.isEmpty
                              ? 'Enter a title'
                              : null),
                      SizedBox(height: 10),
                      LocooTextField(
                          maxLines: 10,
                          height: 220,
                          controller: controller.descriptionController,
                          // textInputAction: TextInputAction.next,
                          label: 'Beschreibung',
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) => value != null && value.isEmpty
                              ? 'Enter a description'
                              : null),
                      SizedBox(height: 10),
                      Center(
                          child: InkWell(
                        onTap: () => controller.showTagDialog(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightGreen,
                          ),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      )),
                      // TagsEditor(),
                      Obx(
                        () => Wrap(
                          children: controller.tags
                              .map((e) => Chip(
                                    deleteIcon: Icon(Icons.close),
                                    onDeleted: () {
                                      controller.removeTag(e);
                                    },
                                    label: Text('#$e'),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GetBuilder<NewPostController>(
                        builder: (c) => controller.image != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(controller.image!),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => controller.deleteImage(),
                                  )
                                ],
                              )
                            : Center(
                                child: IconButton(
                                  icon: const Icon(Icons.upload),
                                  onPressed: () =>
                                      controller.selectImage(context),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      FilterRangeSlider(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        BottomNavBar(controller: controller),
      ],
    );
  }
}
