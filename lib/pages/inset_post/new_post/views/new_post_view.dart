import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/publish_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../new_post_controller.dart';
import '../widgets/back_outlined_button.dart';
import '../widgets/circle_step.dart';
import '../widgets/new_post_title.dart';
import '../widgets/progress_line.dart';
import 'package:openai_client/openai_client.dart';

import '../widgets/tags_element.dart';
import '../widgets/title_field.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class NewPostView extends StatelessWidget {
  final bool hasSubcategories;
  const NewPostView(
      {Key? key, required this.controller, this.hasSubcategories = true})
      : super(key: key);

  final NewPostController controller;

  @override
  Widget build(BuildContext context) {
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
                  CircleStep(3, AppLocalizations.of(context)!.step1, () {}),
                  const ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(1, AppLocalizations.of(context)!.step2, () {}),
                  const ProgressLine(
                    isFinished: false,
                  ),
                  CircleStep(2, AppLocalizations.of(context)!.step3, () {}),
                ],
              ),
            ],
          ),
        ),
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
                        // SizedBox(height: 28),
                        //tile small Wähle deien Kategorie
                        Text(
                          // show category, and if subcategory is avabile add " - " and ontroller.subcategory.name.toString()
                          controller.categoryName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    // color: Theme.of(context).secondaryHeaderColor,
                                  ),
                        ),
                        //tile small Schritt 1 von 3
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.step2of3,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              // fontSize: 18,
                              // fontWeight: FontWeight.w600,
                              // color: Theme.of(context).secondaryHeaderColor,
                              ),
                        ),
                        const SizedBox(height: 20),

                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              TitleField(
                                controller: controller,
                                descriptionController:
                                    controller.descriptionController,
                                titleController: controller.titleController,
                              ),
                              const SizedBox(height: 10),
                              LocooTextField(
                                  maxLines: 10,
                                  height: 220,
                                  controller: controller.descriptionController,

                                  // textInputAction: TextInputAction.next,
                                  label:
                                      AppLocalizations.of(context)!.description,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: (value) =>
                                      value != null && value.isEmpty
                                          ? AppLocalizations.of(context)!
                                              .enterDescription
                                          : null),
                            ],
                          ),
                        ),

                        // SizedBox(height: 10),

                        if (controller.category == CategoryOptions.Event) ...[
                          const SizedBox(height: 10),
                          Form(
                            key: controller.eventKey,
                            child: Column(
                              children: [
                                LocooTextField(
                                    controller:
                                        controller.eventLocationController,
                                    textInputAction: TextInputAction.next,
                                    label:
                                        AppLocalizations.of(context)!.location,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? AppLocalizations.of(context)!
                                                .enterLocation
                                            : null),
                                const SizedBox(height: 10),
                                LocooTextField(
                                  controller: controller.eventTimeController,
                                  label: AppLocalizations.of(context)!.date,
                                  readOnly: true,
                                  enableInteractiveSelection: false,
                                  focusNode: FocusNode(),
                                  autovalidateMode: AutovalidateMode.disabled,
                                  validator: (value) => value != null &&
                                          value.isEmpty
                                      ? AppLocalizations.of(context)!.enterTime
                                      : null,
                                  // text inside the textfield

                                  onTap: () async {
                                    List<DateTime>? dateTimeList =
                                        await showOmniDateTimeRangePicker(
                                      context: context,
                                      type: OmniDateTimePickerType.dateAndTime,

                                      is24HourMode: true,
                                      isShowSeconds: false,
                                      startInitialDate: DateTime.now(),
                                      startFirstDate: DateTime(1600)
                                          .subtract(const Duration(days: 3652)),
                                      startLastDate: DateTime.now().add(
                                        const Duration(days: 3652),
                                      ),
                                      endInitialDate: DateTime.now()
                                          .add(const Duration(hours: 1)),
                                      endFirstDate: DateTime(1600)
                                          .subtract(const Duration(days: 3652)),
                                      endLastDate: DateTime.now().add(
                                        const Duration(days: 3652),
                                      ),
                                      // borderRadius: const Radius.circular(16),
                                    );
                                    controller.setEventTime(dateTimeList);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],

                        NewPostTitle(
                            label: AppLocalizations.of(context)!.addImage),
                        // AddPhotoComingSoon(),
                        GetBuilder<NewPostController>(
                          builder: (c) => AddPhotoElement(
                            image: controller.image,
                            selectImage: controller.selectImage,
                            deleteImage: controller.deleteImage,
                            editImage: controller.editImage,
                          ),
                        ),
                        NewPostTitle(label: AppLocalizations.of(context)!.tags),
                        TagsElement(
                          descriptionController:
                              controller.descriptionController,
                          titleController: controller.titleController,
                          tags: controller.tags,
                          removeTag: controller.removeTag,
                          showTagDialog: controller.showTagDialog,
                          addTag: controller.addTag,
                        ),

                        // Home(),
                        // const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: // left 10 righ t10
                        EdgeInsets.symmetric(horizontal: 10),
                    child: GetBuilder<NewPostController>(
                      id: 'PostRangeSlider',
                      builder: (c) => FilterRangeSlider(
                          sliderValue: controller.sliderValue,
                          onChanged: controller.onSliderValueChanged),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
        BottomNavBar(controller: controller),
      ],
    );
  }
}

// class AddPhotoComingSoon extends StatelessWidget {
//   const AddPhotoComingSoon({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 80,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             FlutterRemix.upload_cloud_2_line,
//             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
//           ),
//           // Text "Coming Soon"
//           Text(
//             "Kommt Bald",
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color:
//                       Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AddPhotoElement extends StatelessWidget {
  const AddPhotoElement(
      {Key? key,
      required this.image,
      required this.selectImage,
      required this.deleteImage,
      required this.editImage})
      : super(key: key);

  final Uint8List? image;
  final Function(BuildContext context) selectImage;
  final Function deleteImage;
  final Function(BuildContext context) editImage;

  @override
  Widget build(BuildContext context) {
    return image != null
        // show a container width: double.infinity,
        // height: 80, with the image and a remove button on the top right
        ? Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: MemoryImage(image!),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => deleteImage(),
                      child: SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: //left 8
                        const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => editImage(context),
                      child: SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () => selectImage(context),
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              ),
              child: Column(
                //center
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Icon(
                    FlutterRemix.upload_cloud_2_line,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.30),
                  ),
                  // text Füge ein Foto hinzu
                  Text(
                    AppLocalizations.of(context)!.addPhoto,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.35),
                        ),
                  ),
                ],
              ),
            ),
          );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({
    Key? key,
    required this.tag,
    required this.removeTag,
  }) : super(key: key);

  final String tag;
  final Function(String tag) removeTag;

  @override
  Widget build(BuildContext context) {
    return Chip(
      deleteIcon: const Icon(
        Icons.close_rounded,
        size: 16,
      ),
      onDeleted: () {
        removeTag(tag);
      },
      backgroundColor: Colors.white,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
      label: Text('#$tag'),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewPostController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: BackOutlinedButton(
              controller: controller,
              icon: Icons.chevron_left_rounded,
              label: AppLocalizations.of(context)!.back,
              onPress: () => controller.jumpBack(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: GetBuilder<NewPostController>(
            builder: (c) => PublishButton(
              controller: controller,
              isPublishing: controller.isLoading,
            ),
          )),
        ],
      ),
    );
  }
}

// //crete a state widget PublishButton

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   late double _distanceToField;
//   late TextfieldTagsController _controller;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _distanceToField = MediaQuery.of(context).size.width;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextfieldTagsController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextFieldTags(
//           textfieldTagsController: _controller,
//           initialTags: const [
//             'pick',
//             'your',
//             'favorite',
//             'programming',
//             'language'
//           ],
//           textSeparators: const [' ', ','],
//           letterCase: LetterCase.normal,
//           validator: (String tag) {
//             if (tag == 'php') {
//               return 'No, please just no';
//             } else if (_controller.getTags!.contains(tag)) {
//               return 'you already entered that';
//             }
//             return null;
//           },
//           inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
//             return ((context, sc, tags, onTagDelete) {
//               return TextField(
//                 maxLines: 3,
//                 controller: tec,
//                 focusNode: fn,
//                 decoration: InputDecoration(
//                   isDense: true,
//                   border: const OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Color.fromARGB(255, 74, 137, 92),
//                       width: 3.0,
//                     ),
//                   ),
//                   focusedBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Color.fromARGB(255, 74, 137, 92),
//                       width: 3.0,
//                     ),
//                   ),
//                   helperText: 'Enter language...',
//                   helperStyle: const TextStyle(
//                     color: Color.fromARGB(255, 74, 137, 92),
//                   ),
//                   hintText: _controller.hasTags ? '' : "Enter tag...",
//                   errorText: error,
//                   prefixIconConstraints:
//                       BoxConstraints(maxWidth: _distanceToField * 0.74),
//                   prefixIcon: tags.isNotEmpty
//                       ? SingleChildScrollView(
//                           controller: sc,
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                               children: tags.map((String tag) {
//                             return Container(
//                               decoration: const BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(20.0),
//                                 ),
//                                 color: Color.fromARGB(255, 74, 137, 92),
//                               ),
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 5.0),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10.0, vertical: 5.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     child: Text(
//                                       '#$tag',
//                                       style:
//                                           const TextStyle(color: Colors.white),
//                                     ),
//                                     onTap: () {
//                                       print("$tag selected");
//                                     },
//                                   ),
//                                   const SizedBox(width: 4.0),
//                                   InkWell(
//                                     child: const Icon(
//                                       Icons.cancel,
//                                       size: 14.0,
//                                       color: Color.fromARGB(255, 233, 233, 233),
//                                     ),
//                                     onTap: () {
//                                       onTagDelete(tag);
//                                     },
//                                   )
//                                 ],
//                               ),
//                             );
//                           }).toList()),
//                         )
//                       : null,
//                 ),
//                 onChanged: onChanged,
//                 onSubmitted: onSubmitted,
//               );
//             });
//           },
//         ),
//         ElevatedButton(
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all<Color>(
//               const Color.fromARGB(255, 74, 137, 92),
//             ),
//           ),
//           onPressed: () {
//             _controller.clearTags();
//           },
//           child: const Text('CLEAR TAGS'),
//         ),
//       ],
//     );
//   }
// }

class ButtonTextField extends StatefulWidget {
  const ButtonTextField({super.key, required this.onPressAdd});

  final Function(String tag) onPressAdd;

  @override
  State<ButtonTextField> createState() => _ButtonTextFieldState();
}

class _ButtonTextFieldState extends State<ButtonTextField> {
  bool isButton = true;
  TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isButton
        ? ElevatedButton(
            // onPressed: () => showTagDialog(context),
            onPressed: () {
              //show text field
              setState(() {
                isButton = false;
                tagController.clear();
                print(isButton);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  AppLocalizations.of(context)!.addTag,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme
                            ?.onPrimary,
                        letterSpacing: -0.07,
                      ),
                ),
              ],
            ),
          )
        : Row(
            children: [
              Expanded(
                child: TextField(
                  // no border 1 padding
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                  controller: tagController,
                  onEditingComplete: () {
                    //show button
                    setState(() {
                      widget.onPressAdd(tagController.text);
                      tagController.clear();
                      isButton = true;
                      print(isButton);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                // onPressed: () => showTagDialog(context),
                onPressed: () {
                  //show text field
                  setState(() {
                    widget.onPressAdd(tagController.text);
                    tagController.clear();
                    isButton = true;
                    print(isButton);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color:
                          Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      AppLocalizations.of(context)!.add,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.onPrimary,
                            letterSpacing: -0.07,
                          ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
