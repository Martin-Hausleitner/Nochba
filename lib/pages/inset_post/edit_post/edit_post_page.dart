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
  const EditPostPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Beitrag bearbeiten'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
        ),
        body: FutureBuilder<bool>(
          future: controller.initializePage(postId),
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

class EditPostView extends StatefulWidget {
  const EditPostView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final EditPostController controller;

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  bool isSelected = false;

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
                            children: widget.controller.mainCategories
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Obx(
                                    () => Row(
                                      children: [
                                        ChoiceChip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.05),
                                          label: Text(entry.value.name),
                                          selected: isSelected,
                                          labelStyle: const TextStyle(
                                            fontSize: 10,
                                            // color: isSelected
                                            //     ? Colors.blue
                                            //     : Colors.red,
                                            color: Colors.black,
                                          ),
                                          selectedColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onSelected: (value) {
                                            widget.controller
                                                .selectCategory(entry.value);
                                            setState(() {
                                              isSelected = value;
                                            });
                                          },
                                        ),
                                        Column(
                                          children: widget.controller
                                              .getSubCategoriesOf(entry.value)
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry2) => ChoiceChip(
                                                  label:
                                                      Text(entry2.value.name),
                                                  selected: widget.controller
                                                      .isSubCategorySelected(
                                                          entry2.value),
                                                  labelStyle: const TextStyle(
                                                      fontSize: 10),
                                                  selectedColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  onSelected: (isSelected) =>
                                                      widget
                                                          .controller
                                                          .selectCategory(
                                                              entry2.value),
                                                ),
                                              )
                                              .toList(),
                                        ),
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
                              widget.controller.categoryName
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
                              controller: widget.controller.titleController,
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
                              controller:
                                  widget.controller.descriptionController,
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
                              image: widget.controller.image,
                              selectImage: widget.controller.selectImage,
                              deleteImage: widget.controller.deleteImage,
                              editImage: widget.controller.editImage,
                            ),
                          ),
                          NewPostTitle(label: 'Tags'),
                          TagsElement(
                            tags: widget.controller.tags,
                            removeTag: widget.controller.removeTag,
                            showTagDialog: widget.controller.showTagDialog,
                            addTag: widget.controller.addTag,
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
        EditPostButton(controller: widget.controller),
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
