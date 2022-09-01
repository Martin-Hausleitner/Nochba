import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/models/category.dart';
import 'package:locoo/models/post.dart';
import 'package:locoo/models/tag.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
import 'package:locoo/views/new_post/tag_dialog.dart';

import 'new_post_controller.dart';
import 'widgets/category_tile.dart';
import 'widgets/circle_step.dart';
import 'widgets/progress_line.dart';

class NewPostPage extends GetView<NewPostController> {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      // appBar: AppBar(
      //   title: const Text('Add a post'),
      //   backgroundColor: Theme.of(context).backgroundColor,
      //   shadowColor: Colors.transparent,
      // ),
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          NewPostCategorySelectionView(),
          NewPostSubcategorySelectionView(),
          NewPostView()
        ],
      ),
    );
  }
}

class NewPostCategorySelectionView extends GetView<NewPostController> {
  const NewPostCategorySelectionView({Key? key}) : super(key: key);

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
              ProgressLine(
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

          Expanded(
            child: GridView.count(
              primary: false,
              // padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                CategoryTile(
                  title: 'Ausleihen',
                  //CategoryOptions.Message.name.toString()
                  icon: FlutterRemix.hand_heart_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Lending);
                  },
                ),
                CategoryTile(
                  title: 'Mitteilung',
                  icon: FlutterRemix.message_2_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Message);
                  },
                ),
                CategoryTile(
                  title: 'Event',
                  icon: FlutterRemix.calendar_event_line,
                  onTap: () {
                    controller.updateCategory(CategoryOptions.Event);
                  },
                ),
                CategoryTile(
                  title: 'Suche',
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

class NewPostSubcategorySelectionView extends GetView<NewPostController> {
  const NewPostSubcategorySelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return Column(
      children: [
        Text('Select a subcategory'),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => Expanded(
            child: ListView.separated(
              itemCount: controller.subcategoriesForDisplay.length,
              itemBuilder: (BuildContext context, int index) {
                final categories = controller.subcategoriesForDisplay;
                return InkWell(
                  onTap: () {
                    controller.updateSubcategory(categories[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen,
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
        IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              controller.jumpBack();
            })
      ],
    );
  }
}

class NewPostView extends StatelessWidget {
  final bool hasSubcategories;
  const NewPostView({Key? key, this.hasSubcategories = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewPostController controller = Get.find<NewPostController>();
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                controller.subcategory != CategoryOptions.None
                    ? controller.subcategory.name.toString()
                    : controller.category.name.toString(),
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
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



//create a progress line with a constructer isfinished when true shwo a green line when false show DottedLine(), in a Expanded widget

