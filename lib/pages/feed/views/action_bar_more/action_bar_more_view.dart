//import dart:ui

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/post.dart';
import 'package:nochba/pages/feed/views/action_bar_more/alert_dialog_delete.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/bottom_sheet_title_close_view.dart';

class ActionBarMore extends StatelessWidget {
  final ActionBarController controller;
  final Post post;
  const ActionBarMore({
    Key? key,
    required this.controller,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(
      title: 'Mehr',
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // ActionCard(
              //   title: 'Beitrag Übersetzten',
              //   icon: Icons.translate_outlined,
              //   onTap: //snackbar
              //       () {
              //     final _PostState postState = post._postState;
              //     if (postState != null) {
              //       setState(() {
              //         postState.startTranslation();
              //       });
              //     }
              //   },
              // ),
              ActionCard(
                title: 'Post melden',
                icon: FlutterRemix.flag_line,
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BottomSheetTitleCloseView(
                        title: 'Post Melden',
                        children: [
                          Padding(
                            padding: //right 15 left 15 bottom 5 top 1
                                const EdgeInsets.only(
                                    right: 15, left: 15, bottom: 5),
                            child: Column(
                              //align left
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //show 10 ActionCards
                                Text(
                                  'Wähle deinen Grund aus',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                //       .copyWith(
                                //           color: Theme.of(context)
                                //               .textTheme
                                //               .bodyText1!
                                //               .color!
                                //               .withOpacity(0.8)),
                                // ),
                                const SizedBox(height: 5),

                                GetBuilder<ActionBarController>(
                                  id: 'ReportPostDropDown',
                                  builder: (c) => DropdownButtonExample(
                                    dropDownValues: controller.reasonsForReport,
                                    selectedValue:
                                        controller.selectedReasonForReport,
                                    selectValue:
                                        controller.selectReasonForReport,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Form(
                                  key: controller.reportKey,
                                  child: Column(
                                    children: [
                                      LocooTextField(
                                          maxLines: 10,
                                          height: 220,
                                          // controller:
                                          // controller.descriptionController,
                                          // textInputAction: TextInputAction.next,
                                          label: 'Beschreibung',
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          controller:
                                              controller.reportTextController,
                                          validator: (value) =>
                                              value != null && value.isEmpty
                                                  ? 'Enter a description'
                                                  : null),
                                      const SizedBox(height: 10),
                                      LocooTextButton(
                                        label: 'Post Melden',
                                        onPressed: () async => await controller
                                            .onPressReportSend(post.id),
                                        icon: FlutterRemix.flag_line,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),

                                //),

                                // ActionCard(
                                //   title: 'Post bearbeiten',
                                //   onTap: () {
                                //     print('test');
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              if (controller.isThisTheCurrentUser(post.uid))
                Column(
                  children: [
                    ActionCard(
                      title: 'Post bearbeiten',
                      icon: FlutterRemix.pencil_line,
                      onTap: () => controller.pushEditPostView(post.id),
                    ),
                    ActionCard(
                      title: 'Post löschen',
                      icon: FlutterRemix.delete_bin_line,
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialogDelete(
                          label: 'Post',
                          onDelete: () {
                            controller.deletePost(post.id);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // ActionCard(
        //     title: 'titlde',
        //     onTap: () {
        //       print('test');
        //     }),
      ],
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample(
      {super.key,
      required this.dropDownValues,
      required this.selectedValue,
      required this.selectValue});

  final List<String> dropDownValues;
  final String? selectedValue;
  final Function(String?) selectValue;

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border:
        // widget.selectedValue == null ? Border.all(color: Colors.red) : null,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),
      child: Padding(
        padding: // left right 5 top 5 bottom 5
            const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
        child: DropdownButton<String>(
          value: widget.selectedValue,
          isExpanded: true,
          icon: const Icon(
            Icons.expand_more_outlined,
          ),
          // elevation: 16,
          style: TextStyle(
            // color: Theme.of(context).primaryColor,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          underline: Container(
            height: 0,
            // color: Theme.of(context).primaryColor,
          ),
          onChanged: widget.selectValue,
          items: widget.dropDownValues
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
