import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:openai_client/openai_client.dart';
import 'package:nochba/env/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'dart:math';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

class TagInputField extends StatefulWidget {
  const TagInputField({
    Key? key,
    required this.tags,
    this.fixedTags,
    required this.removeTag,
    required this.showTagDialog,
    required this.addTag,
    this.descriptionController,
    this.titleController,
    required this.addText,
  }) : super(key: key);

  final List<String> tags;
  final Function(String tag) removeTag;
  final Function(BuildContext context) showTagDialog;
  final Function(String tag) addTag;
  final TextEditingController? descriptionController;
  final TextEditingController? titleController;
  final List<String>? fixedTags;
  final String addText;

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  List<String> tags = [];

  void addTagsToWidget(String chatOutput) {
    List<String> tagsToAdd = [];
    for (String tag in widget.tags) {
      if (!widget.fixedTags!.contains(tag)) {
        tagsToAdd.add(tag);
      }
    }
    if (tagsToAdd.isNotEmpty) {
      setState(() {
        tags.addAll(tagsToAdd);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tags = List<String>.from(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ...widget.fixedTags!
                        .map(
                          (tag) => FilterChip(
                            label: Text(
                              '$tag',
                              style: TextStyle(
                                color: tags.contains(tag)
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                            selected: tags.contains(tag),
                            onSelected: (isSelected) {
                              if (isSelected) {
                                setState(() {
                                  tags.add(tag);
                                });
                              } else {
                                setState(() {
                                  tags.remove(tag);
                                });
                              }
                            },
                            showCheckmark: false,
                            avatar: tags.contains(tag)
                                ? Icon(
                                    Icons.check,
                                    size: 18.0,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : null,
                            backgroundColor: Colors.white,
                            selectedColor: Colors.white,
                            selectedShadowColor: Colors.transparent,
                            elevation: 0,
                            pressElevation: 0,
                            // materialTapTargetSize:
                            //     MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: tags.contains(tag)
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.1),
                                width: 1.0,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    ...tags
                        .where((tag) => !widget.fixedTags!.contains(tag))
                        .map(
                          (tag) => TagChip(
                            tag: tag,
                            removeTag: (tag) {
                              setState(() {
                                tags.remove(tag);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
            // const SizedBox(height: 8),
            ButtonTextField(
                addText: widget.addText,
                onPressAdd: (tag) {
                  setState(() {
                    tags.add(tag);
                  });
                }),
          ],
        ),
      ],
    );
  }
}

class ButtonTextField extends StatefulWidget {
  const ButtonTextField(
      {super.key, required this.onPressAdd, required this.addText});

  final Function(String tag) onPressAdd;
  final String addText;

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
            onPressed: () {
              setState(() {
                isButton = false;
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  //addText
                  widget.addText,
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
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                  controller: tagController,
                  onSubmitted: (text) {
                    widget.onPressAdd(tagController.text);
                    tagController.clear();
                    setState(() {
                      isButton = true;
                      print(isButton);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  widget.onPressAdd(tagController.text);
                  tagController.clear();
                  setState(() {
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
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FlutterRemix.add_line,
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
              ),
            ],
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
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
      label: Text(
        '$tag',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      deleteIconColor: Theme.of(context).primaryColor,
    );
  }
}
