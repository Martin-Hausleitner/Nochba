import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:nochba/pages/inset_post/new_post/views/new_post_view.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/new_post_title.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';

class EditPostPage extends GetView<EditPostController> {
  EditPostPage({super.key, required this.post}) {
    //controller.initializePage(post);
  }

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Post bearbeiten',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  // color: Theme.of(context).colorScheme.onSecondaryContainer,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
        ),
        body: FutureBuilder<bool>(
          future: controller.initializePage(post),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('The edit page is not available now'));
            } else if (snapshot.hasData) {
              return EditPostView(controller: controller);
            } else {
              return Container();
            }
          }),
        ));
  }
}

class EditPostView extends StatelessWidget {
  const EditPostView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final EditPostController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      // align start
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Expanded(
          child: ListView(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      //left right 25
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: controller.mainCategories
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Obx(
                                    () => Row(
                                      children: [
                                        ChoiceChip(
                                            label: Text(entry.value.name),
                                            selected: controller
                                                .isMainCategorySelected(
                                                    entry.value),
                                            labelStyle:
                                                const TextStyle(fontSize: 10),
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            onSelected: (isSelected) =>
                                                controller.selectCategory(
                                                    entry.value)),
                                        Column(
                                          children: controller
                                              .getSubCategoriesOf(entry.value)
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry2) => ChoiceChip(
                                                    label:
                                                        Text(entry2.value.name),
                                                    selected: controller
                                                        .isSubCategorySelected(
                                                            entry2.value),
                                                    labelStyle: const TextStyle(
                                                        fontSize: 10),
                                                    selectedColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    onSelected: (isSelected) =>
                                                        controller
                                                            .selectCategory(
                                                                entry2.value)),
                                              )
                                              .toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          // SizedBox(height: 28),
                          //tile small Wähle deien Kategorie
                          Obx(
                            () => Text(
                              controller.categoryName
                              // show category, and if subcategory is avabile add " - " and ontroller.subcategory.name.toString()
                              /*controller.subcategory != CategoryOptions.None
                                      ? "${controller.category.name.toString()} - ${controller.subcategory.name.toString()}"
                                      : controller.category.name.toString()*/
                              ,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    // color: Theme.of(context).secondaryHeaderColor,
                                  ),
                            ),
                          ),
                          //tile small Schritt 1 von 3
                          SizedBox(height: 20),

                          LocooTextField(
                              controller: controller.titleController,
                              textInputAction: TextInputAction.next,
                              label: 'Titel',
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: (value) =>
                                  value != null && value.isEmpty
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
                              validator: (value) =>
                                  value != null && value.isEmpty
                                      ? 'Enter a description'
                                      : null),

                          NewPostTitle(label: 'Bild Hinzufügen'),
                          GetBuilder<EditPostController>(
                            builder: (c) => AddPhotoElement(
                              image: controller.image,
                              selectImage: controller.selectImage,
                              deleteImage: controller.deleteImage,
                              editImage: controller.editImage,
                            ),
                          ),
                          NewPostTitle(label: 'Tags'),
                          TagsElement(
                            tags: controller.tags,
                            removeTag: controller.removeTag,
                            showTagDialog: controller.showTagDialog,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: // left 10 righ t10
                          const EdgeInsets.symmetric(horizontal: 10),
                      child: FilterRangeSlider(),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        EditPostButton(controller: controller),
      ],
    );
  }
}

class EditPostButton extends StatelessWidget {
  const EditPostButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final EditPostController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: ElevatedButton.icon(
          onPressed: //controller.addPost() and go to
              () => controller.updatePost(),
          icon: Icon(
            Icons.done_outlined,
          ),
          label: Text(
            'Aktualisieren',
            style: Theme.of(context).textTheme.button?.copyWith(
                  color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                  letterSpacing: -0.07,
                ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: const Size.fromHeight(60),
            shadowColor: Colors.transparent,
            // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          ),
        ),
      ),
    );
  }
}
