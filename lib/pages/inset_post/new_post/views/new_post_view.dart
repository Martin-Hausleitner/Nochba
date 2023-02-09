import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
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
                'Beitrag erstellen',
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
                  CircleStep(3, '1', () {}),
                  const ProgressLine(
                    isFinished: true,
                  ),
                  CircleStep(1, '2', () {}),
                  const ProgressLine(
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
                child: Column(
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  // color: Theme.of(context).secondaryHeaderColor,
                                ),
                          ),
                          //tile small Schritt 1 von 3
                          const SizedBox(height: 2),
                          Text(
                            'Schritt 2 von 3',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                // fontSize: 18,
                                // fontWeight: FontWeight.w600,
                                // color: Theme.of(context).secondaryHeaderColor,
                                ),
                          ),
                          const SizedBox(height: 20),

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
                          // SizedBox(height: 10),

                          if (controller.categoryName == 'Event') ...[
                            const SizedBox(height: 10),
                            LocooTextField(
                              // controller: controller.locationController,
                              textInputAction: TextInputAction.next,
                              label: 'Ort',
                              autovalidateMode: AutovalidateMode.disabled,
                            ),
                            const SizedBox(height: 10),
                            LocooTextField(
                              label: 'Datum',
                              readOnly: true,
                              enableInteractiveSelection: false,
                              focusNode: FocusNode(),
                              // text inside the textfield

                              onTap: () async {
                                List<DateTime>? dateTimeList =
                                    await showOmniDateTimeRangePicker(
                                  context: context,
                                  type: OmniDateTimePickerType.dateAndTime,
                                  primaryColor: Theme.of(context).primaryColor,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  calendarTextColor: Colors.black,
                                  tabTextColor: Colors.black,
                                  unselectedTabBackgroundColor: // gray 300 color
                                      Colors.grey[300],
                                  buttonTextColor: Colors.black,
                                  timeSpinnerTextStyle: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  timeSpinnerHighlightedTextStyle:
                                      const TextStyle(
                                          color: Colors.black, fontSize: 24),
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
                                  borderRadius: const Radius.circular(16),
                                );
                              },
                            ),
                          ],

                          const NewPostTitle(label: 'Bild Hinzufügen'),
                          GetBuilder<NewPostController>(
                            builder: (c) => AddPhotoElement(
                              image: controller.image,
                              selectImage: controller.selectImage,
                              deleteImage: controller.deleteImage,
                              editImage: controller.editImage,
                            ),
                          ),
                          const NewPostTitle(label: 'Tags'),
                          TagsElement(
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
                    const Padding(
                      padding: // left 10 righ t10
                          EdgeInsets.symmetric(horizontal: 10),
                      child: FilterRangeSlider(),
                    ),
                    const SizedBox(height: 20),
                  ],
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

        // ? Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       CircleAvatar(
        //         backgroundImage:
        //             MemoryImage(controller.image!),
        //       ),
        //       IconButton(
        //         icon: const Icon(
        //           Icons.close_rounded,
        //         ),
        //         onPressed: () =>
        //             controller.deleteImage(),
        //       )
        //     ],
        //   )
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
                    'Füge ein Foto hinzu',
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

class TagsElement extends StatelessWidget {
  const TagsElement(
      {Key? key,
      required this.tags,
      required this.removeTag,
      required this.showTagDialog,
      required this.addTag})
      : super(key: key);

  final List<String> tags;
  final Function(String tag) removeTag;
  final Function(BuildContext context) showTagDialog;
  final Function(String tag) addTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      // round corners and Theme.of(context)
      // .colorScheme
      // .onSurface
      // .withOpacity(0.05),
      //width full
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),

      child: Padding(
        padding: // left 8 right 8 bottom 8 top 0
            const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          //start
          children: [
            //when the tags are not emty whow a sizedbox
            //height 10

            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tags.isNotEmpty)
                    const SizedBox(
                      height: 8,
                    ),
                  Padding(
                    padding: const //top 8
                        EdgeInsets.only(top: 0),
                    child: Wrap(
                      //vertaicla padding
                      spacing: 4,
                      runSpacing: 4,
                      children: tags
                          .map((e) => Chip(
                                deleteIcon: const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                ),
                                onDeleted: () {
                                  removeTag(e);
                                },
                                backgroundColor: Colors.white,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                label: Text('#$e'),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            //show sizedbox height 10 when more then 1 tag is in the list
            const SizedBox(height: 8),

            ButtonTextField(onPressAdd: addTag),
          ],
        ),
      ),
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
              label: 'Zurück',
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

//crete a state widget PublishButton

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldTags(
          textfieldTagsController: _controller,
          initialTags: const [
            'pick',
            'your',
            'favorite',
            'programming',
            'language'
          ],
          textSeparators: const [' ', ','],
          letterCase: LetterCase.normal,
          validator: (String tag) {
            if (tag == 'php') {
              return 'No, please just no';
            } else if (_controller.getTags!.contains(tag)) {
              return 'you already entered that';
            }
            return null;
          },
          inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              return TextField(
                maxLines: 3,
                controller: tec,
                focusNode: fn,
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 74, 137, 92),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 74, 137, 92),
                      width: 3.0,
                    ),
                  ),
                  helperText: 'Enter language...',
                  helperStyle: const TextStyle(
                    color: Color.fromARGB(255, 74, 137, 92),
                  ),
                  hintText: _controller.hasTags ? '' : "Enter tag...",
                  errorText: error,
                  prefixIconConstraints:
                      BoxConstraints(maxWidth: _distanceToField * 0.74),
                  prefixIcon: tags.isNotEmpty
                      ? SingleChildScrollView(
                          controller: sc,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: tags.map((String tag) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Color.fromARGB(255, 74, 137, 92),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      '#$tag',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      print("$tag selected");
                                    },
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 14.0,
                                      color: Color.fromARGB(255, 233, 233, 233),
                                    ),
                                    onTap: () {
                                      onTagDelete(tag);
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList()),
                        )
                      : null,
                ),
                onChanged: onChanged,
                onSubmitted: onSubmitted,
              );
            });
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 74, 137, 92),
            ),
          ),
          onPressed: () {
            _controller.clearTags();
          },
          child: const Text('CLEAR TAGS'),
        ),
      ],
    );
  }
}

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
                  'Tag hinzufügen',
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
                      'Add',
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

//     return SingleChildScrollView(
//       // padding: EdgeInsets.all(25),
//       child: Form(
//         key: controller.formKey,
//         child: Column(
//           //spaceBetween
//           crossAxisAlignment: CrossAxisAlignment.start,
//           // mainAxisAlignment: MainAxisAlignment.center,
//           // crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Post erstellen',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: -0.5,
//                         // color: Theme.of(context).colorScheme.onSecondaryContainer,
//                         color: Theme.of(context)
//                             .colorScheme
//                             .onSecondaryContainer,
//                       ),
//                 ),
//                 SizedBox(height: 28),
//                 Row(
//                   children: [
//                     CircleStep(3, '1', () {}),
//                     ProgressLine(
//                       isFinished: true,
//                     ),
//                     CircleStep(1, '2', () {}),
//                     ProgressLine(
//                       isFinished: false,
//                     ),
//                     CircleStep(2, '3', () {}),
//                   ],
//                 ),
//                 SizedBox(height: 28),
//                 //tile small Wähle deien Kategorie
//                 Text(
//                   // show category, and if subcategory is avabile add " - " and ontroller.subcategory.name.toString()
//                   controller.subcategory != CategoryOptions.None
//                       ? "${controller.category.name.toString()} - ${controller.subcategory.name.toString()}"
//                       : controller.category.name.toString(),

//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                         // color: Theme.of(context).secondaryHeaderColor,
//                       ),
//                 ),
//                 //tile small Schritt 1 von 3
//                 SizedBox(height: 2),
//                 Text(
//                   'Schritt 2 von 3',
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       // fontSize: 18,
//                       // fontWeight: FontWeight.w600,
//                       // color: Theme.of(context).secondaryHeaderColor,
//                       ),
//                 ),

//                 TextFormField(
//                     controller: controller.titleController,
//                     textInputAction: TextInputAction.done,
//                     decoration: const InputDecoration(labelText: 'Title'),
//                     autovalidateMode: AutovalidateMode.disabled,
//                     validator: (value) => value != null && value.isEmpty
//                         ? 'Enter a title'
//                         : null),
//                 SizedBox(height: 40),
//                 TextFormField(
//                     controller: controller.descriptionController,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(labelText: 'Description'),
//                     autovalidateMode: AutovalidateMode.disabled,
//                     validator: (value) => value != null && value.isEmpty
//                         ? 'Enter a description'
//                         : null),
//                 SizedBox(height: 10),
//                 Center(
//                     child: InkWell(
//                   onTap: () => controller.showTagDialog(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.lightGreen,
//                     ),
//                     child: Icon(Icons.add, color: Colors.white),
//                   ),
//                 )),
//                 Obx(
//                   () => Wrap(
//                     children: controller.tags
//                         .map((e) => Chip(
//                               deleteIcon: Icon(Icons.close_rounded),
//                               onDeleted: () {
//                                 controller.removeTag(e);
//                               },
//                               label: Text('#$e'),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 GetBuilder<NewPostController>(
//                   builder: (c) => controller.image != null
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: MemoryImage(controller.image!),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close_rounded),
//                               onPressed: () => controller.deleteImage(),
//                             )
//                           ],
//                         )
//                       : Center(
//                           child: IconButton(
//                             icon: const Icon(Icons.upload),
//                             onPressed: () => controller.selectImage(context),
//                           ),
//                         ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: BackOutlinedButton(
//                         controller: controller,
//                         icon: Icons.arrow_back_rounded,
//                         label: 'Zurück'),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                       child: NextElevatedButton(
//                     onPressed: //controller.addPost() and go to
//                         () {
//                       controller.addPost();
//                       controller.jumpToPage(4);
//                       // Get.to(PublishedNewPostView());
//                     },
//                     controller: controller,
//                     icon: Icons.done_outlined,
//                     label: 'Veröffenlichen',
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
