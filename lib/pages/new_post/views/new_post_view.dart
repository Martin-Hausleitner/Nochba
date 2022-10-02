import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:textfield_tags/textfield_tags.dart';

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
                      Home(),
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
              icon: FlutterRemix.arrow_left_s_line,
              label: 'Zurück',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: NextElevatedButton(
            onPressed: //controller.addPost() and go to
                () {
              controller.addPost();
              // controller.pageController.nextPage(
              //     duration: const Duration(milliseconds: 1),
              //     curve: Curves.easeInOut);
              //controller.jumpToPage(4);
              //close keyboard
              FocusScope.of(context).unfocus();
              // Get.to(PublishedNewPostView());
            },
            controller: controller,
            icon: Icons.done_outlined,
            label: 'Veröffenlichen',
          )),
        ],
      ),
    );
  }
}

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
//                               deleteIcon: Icon(Icons.close),
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
//                               icon: const Icon(Icons.close),
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
//                         icon: FlutterRemix.arrow_left_s_line,
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
