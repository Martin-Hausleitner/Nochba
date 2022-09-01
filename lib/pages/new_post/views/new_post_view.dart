import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';

import '../new_post_controller.dart';
import '../widgets/circle_step.dart';
import '../widgets/progress_line.dart';

class NewPostView extends StatelessWidget {
  final bool hasSubcategories;
  const NewPostView({Key? key, this.hasSubcategories = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 28),
            //tile small Wähle deien Kategorie
            Text(
              // show category, and if subcategory is avabile add " - " and ontroller.subcategory.name.toString()
              controller.subcategory != CategoryOptions.None
                  ? "${controller.category.name.toString()} - ${controller.subcategory.name.toString()}"
                  : controller.category.name.toString(),

              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

            TextFormField(
                controller: controller.titleController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Title'),
                autovalidateMode: AutovalidateMode.disabled,
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter a title' : null),
            SizedBox(height: 40),
            TextFormField(
                controller: controller.descriptionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Description'),
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
                          backgroundImage: MemoryImage(controller.image!),
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
                        onPressed: () => controller.selectImage(context),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            LocooTextButton(
              text: 'Add Post',
              onPressed: () => controller.addPost(),
              icon: FlutterRemix.account_box_fill,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                controller.jumpBack();
              },
            )
          ],
        ),
      ),
    );
  }
}
