import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/Comment.dart';
import 'package:nochba/pages/comments/comment_controller.dart';
import 'package:nochba/pages/feed/views/action_bar_more/action_bar_more_view.dart';
import 'package:nochba/pages/feed/views/action_bar_more/alert_dialog_delete.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/buttons/text_field_remove_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/bottom_sheet_close_save_view.dart';
import 'package:nochba/shared/views/bottom_sheet_title_close_view.dart';

class ActionBarMore extends StatelessWidget {
  final Comment comment;
  final CommentController controller;
  const ActionBarMore({
    Key? key,
    required this.comment,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(
      title: 'Mehr',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              ActionCard(
                title: 'Kommentar melden',
                icon: FlutterRemix.flag_line,
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BottomSheetTitleCloseView(
                        title: 'Kommentar Melden',
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
                                SizedBox(height: 5),

                                DropdownButtonExample(),
                                SizedBox(height: 10),

                                LocooTextField(
                                    maxLines: 10,
                                    height: 220,
                                    // controller:
                                    // controller.descriptionController,
                                    // textInputAction: TextInputAction.next,
                                    label: 'Beschreibung',
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? 'Enter a description'
                                            : null),
                                SizedBox(height: 10),
                                LocooTextButton(
                                  label: 'Post Melden',
                                  onPressed: () {},
                                  icon: FlutterRemix.flag_line,
                                ),
                                SizedBox(height: 10),

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
              if (controller.isThisTheCurrentUser(comment.user))
                Column(
                  children: [
                    ActionCard(
                      title: 'Kommentar bearbeiten',
                      icon: FlutterRemix.pencil_line,
                      onTap: () => {
                        showModalBottomSheet<void>(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0))),
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return BottomSheetCloseSaveView(
                              onSave: () async =>
                                  await controller.updateTextOfComment(
                                      comment.post, comment.id),
                              children: [
                                LocooTextField(
                                  label: 'Text',
                                  suffixIcon: TextFieldRemoveTextButton(
                                    onPressed: () =>
                                        controller.updateTextController.clear(),
                                  ),
                                  autofocus: true,
                                  controller: controller
                                      .getTextController(comment.text),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        )
                      },
                    ),
                    ActionCard(
                      title: 'Kommentar löschen',
                      icon: FlutterRemix.delete_bin_line,
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialogDelete(
                          label: 'Kommentar',
                          onDelete: () {
                            controller.deleteComment(comment.post, comment.id);
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
        SizedBox(
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
