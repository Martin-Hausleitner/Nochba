import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/pages/feed/feed_page.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:nochba/pages/inset_post/new_post/views/new_post_view.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/new_post_title.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/tags_element.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_remix/flutter_remix.dart';

class EditPostPage extends GetView<EditPostController> {
  const EditPostPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.editPost),
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
        // const SizedBox(height: 30),
        Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    //left right 25
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        GetBuilder<EditPostController>(
                          builder: (c) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // algin start
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CategoryChooser(controller: controller),
                              if (controller
                                  .hasSelectedCategorySubCategories()) ...[
                                const SizedBox(height: 10),
                                SubCategoryChooser(controller: controller),
                              ]
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              LocooTextField(
                                  controller: controller.titleController,
                                  textInputAction: TextInputAction.next,
                                  label: 'Titel',
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: (value) =>
                                      value != null && value.isEmpty
                                          ? 'Enter a title'
                                          : null),
                              const SizedBox(height: 10),
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
                            ],
                          ),
                        ),
                        GetBuilder<EditPostController>(
                          builder: (c) => Column(
                            children: [
                              if (controller.category ==
                                  CategoryOptions.Event) ...[
                                const SizedBox(height: 10),
                                Form(
                                  key: controller.eventKey,
                                  child: Column(
                                    children: [
                                      Location(controller: controller),
                                      const SizedBox(height: 10),
                                      DatePicker(controller: controller),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const NewPostTitle(label: 'Bild Hinzufügen'),
                        AddPhotoComingSoon(),
                        // GetBuilder<EditPostController>(
                        //   builder: (c) {
                        //     print("Image: ${controller.image}");
                        //     print("Select Image: ${controller.selectImage}");
                        //     print("Delete Image: ${controller.deleteImage}");
                        //     print("Edit Image: ${controller.editImage}");
                        //     return AddPhotoElement(
                        //       image: controller.image,
                        //       selectImage: controller.selectImage,
                        //       deleteImage: controller.deleteImage,
                        //       editImage: controller.editImage,
                        //     );
                        //   },
                        // ),
                        const NewPostTitle(label: 'Tags'),
                        TagsElement(
                          descriptionController:
                              controller.descriptionController,
                          titleController: controller.titleController,
                          tags: controller.tags,
                          removeTag: controller.removeTag,
                          showTagDialog: controller.showTagDialog,
                          addTag: controller.addTag,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: // left 10 righ t10
                          const EdgeInsets.symmetric(horizontal: 10),
                      child: GetBuilder<EditPostController>(
                        id: 'PostRangeSlider',
                        builder: (c) => FilterRangeSlider(
                            sliderValue: controller.sliderValue,
                            onChanged: controller.onSliderValueChanged),
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
        EditPostButton(controller: controller),
      ],
    );
  }
}

class AddPhotoComingSoon extends StatelessWidget {
  const AddPhotoComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FlutterRemix.upload_cloud_2_line,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
          ),
          // Text "Coming Soon"
          Text(
            "Kommt Bald",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
                ),
          ),
        ],
      ),
    );
  }
}

class CategoryChooser extends StatelessWidget {
  const CategoryChooser({
    super.key,
    required this.controller,
  });

  final EditPostController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategorie',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.mainCategories
                  .map(
                (entry) => CategorieChip(
                    label: controller.getCategoryName(entry),
                    category: entry,
                    isSelected: controller.isMainCategorySelected,
                    onTap: controller.selectCategory),
              )
                  .fold(
                      [],
                      (previousValue, element) => [
                            ...previousValue,
                            ...[element, const SizedBox(width: 10)]
                          ]),
            ),
          ),
        ],
      ),
    );
  }
}

class SubCategoryChooser extends StatelessWidget {
  const SubCategoryChooser({
    super.key,
    required this.controller,
  });

  final EditPostController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unterkategorie',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller
                  .getSubCategoriesOfSelectedCategory()
                  .asMap()
                  .entries
                  .map(
                    (entry) => CategorieChip(
                        label: controller.getCategoryName(entry.value),
                        category: entry.value,
                        isSelected: controller.isSubCategorySelected,
                        onTap: controller.selectCategory),
                  )
                  .fold(
                [],
                (previousValue, element) => [
                  ...previousValue,
                  ...[element, const SizedBox(width: 10)],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Location extends StatelessWidget {
  const Location({
    super.key,
    required this.controller,
  });

  final EditPostController controller;

  @override
  Widget build(BuildContext context) {
    return LocooTextField(
        controller: controller.eventLocationController,
        textInputAction: TextInputAction.next,
        label: 'Ort',
        autovalidateMode: AutovalidateMode.disabled,
        validator: (value) =>
            value != null && value.isEmpty ? 'Geben Sie einen Ort ein' : null);
  }
}

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.controller,
  });

  final EditPostController controller;

  @override
  Widget build(BuildContext context) {
    return LocooTextField(
      controller: controller.eventTimeController,
      label: 'Datum',
      readOnly: true,
      enableInteractiveSelection: false,
      focusNode: FocusNode(),
      autovalidateMode: AutovalidateMode.disabled,
      validator: (value) =>
          value != null && value.isEmpty ? 'Geben Sie eine Zeit ein' : null,
      // text inside the textfield

      onTap: () async {
        List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
          context: context,
          type: OmniDateTimePickerType.dateAndTime,
          // primaryColor: Theme.of(context).primaryColor,
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // calendarTextColor: Colors.black,
          // tabTextColor: Colors.black,
          // unselectedTabBackgroundColor: // gray 300 color
          //     Colors.grey[300],
          // buttonTextColor: Colors.black,
          // timeSpinnerTextStyle:
          //     const TextStyle(color: Colors.black, fontSize: 18),
          // timeSpinnerHighlightedTextStyle:
          //     const TextStyle(color: Colors.black, fontSize: 24),
          is24HourMode: true,
          isShowSeconds: false,
          startInitialDate: DateTime.now(),
          startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
          startLastDate: DateTime.now().add(
            const Duration(days: 3652),
          ),
          endInitialDate: DateTime.now().add(const Duration(hours: 1)),
          endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
          endLastDate: DateTime.now().add(
            const Duration(days: 3652),
          ),
          // borderRadius: const Radius.circular(16),
        );
        controller.setEventTime(dateTimeList);
      },
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
      child: ElevatedButton.icon(
        onPressed: //controller.addPost() and go to
            () => controller.updatePost(),
        icon: const Icon(
          Icons.done_outlined,
        ),
        label: Text(
          'Aktualisieren',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
    );
  }
}
