import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:openai_client/openai_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/new_post_view.dart';
import 'dart:math';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TagsElement extends StatefulWidget {
  const TagsElement({
    Key? key,
    required this.tags,
    required this.removeTag,
    required this.showTagDialog,
    required this.addTag,
    this.descriptionController,
    this.titleController,
  }) : super(key: key);

  final List<String> tags;
  final Function(String tag) removeTag;
  final Function(BuildContext context) showTagDialog;
  final Function(String tag) addTag;
  final TextEditingController? descriptionController;
  final TextEditingController? titleController;

  @override
  State<TagsElement> createState() => _TagsElementState();
}

class _TagsElementState extends State<TagsElement> {
  bool _isLoading = false;
  int _maxCalls = 20;

  Future<void> callOpenAI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int callCount = prefs.getInt('callOpenAI_count') ?? 0;

    if (callCount == 0) {
      Get.snackbar('Info', 'You only have 20 calls left.');
    } else if (callCount >= _maxCalls - 5 && callCount < _maxCalls) {
      Get.snackbar(
          'Info', 'You only have ${_maxCalls - callCount} calls left.');
    } else if (callCount >= _maxCalls) {
      Get.snackbar('Info', 'You have no calls left.');
      return;
    }

    try {
      final String apiKey = dotenv.env['OPENAI_API_KEY']!;
      final String organizationId = dotenv.env['OPENAI_ORGANIZATION_ID']!;
      final conf = OpenAIConfiguration(
        apiKey: apiKey,
        organizationId: organizationId,
      );

      final client = OpenAIClient(
        configuration: conf,
        enableLogging: true,
      );

      if (widget.descriptionController!.text.isEmpty) {
        print(widget.descriptionController!.text);
        Get.snackbar(
            'Error', 'Please add a description to the post!');
        return;
      }

      if (widget.titleController!.text.isEmpty) {
        print(widget.titleController!.text);
        Get.snackbar('Error', 'Please add a title to the post!');
        return;
      }

      final String prompt =
          'This is a post about ${widget.titleController!.text}. ${widget.descriptionController!.text}';
      final chat = await client.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          ChatMessage(
            role: 'user',
            content: prompt,
          )
        ],
      ).data;

      final response = chat.choices[0].message.content;
      print(response);
      String interpolatedString = '["#$response';

      setState(() {
        addTagsToWidget(interpolatedString);
      });
      await prefs.setInt('callOpenAI_count', callCount + 1);
    } catch (e, stackTrace) {
      print('Error calling OpenAI API: $e');
      print(stackTrace);
      Get.snackbar(
          'Error', 'There was an error calling the OpenAI API.');
    }
  }

  List<String> parseTags(String chatOutput) {
    RegExp regExp = RegExp(r'(?<=#)[\p{Letter}]+', unicode: true);
    Iterable<RegExpMatch> matches = regExp.allMatches(chatOutput);
    List<String> tags = [];

    for (RegExpMatch match in matches) {
      String tag = match.group(0)!;
      tags.add(tag);
    }

    print(tags.toString());

    return tags;
  }

  void addTagsToWidget(String chatOutput) {
    List<String> newTags = parseTags(chatOutput);
    if (newTags.isEmpty) {
      Get.snackbar(
          'Error', 'There was an error calling the OpenAI API.');
      return;
    }

    List<String> tagsToAdd = [];
    for (String tag in newTags) {
      if (!widget.tags.contains(tag)) {
        tagsToAdd.add(tag);
      }
    }

    if (tagsToAdd.isNotEmpty) {
      setState(() {
        widget.tags.addAll(tagsToAdd);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.tags.isNotEmpty)
                        const SizedBox(
                          height: 8,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: widget.tags
                              .map(
                                (tag) => TagChip(
                                  tag: tag,
                                  removeTag: widget.removeTag,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ButtonTextField(onPressAdd: widget.addTag),
              ],
            ),
          ),
        ),
        Positioned(
          top: 1.8,
          right: 0,
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading =
                          true; // Set _isLoading to true when loading starts
                    });
                    await callOpenAI();
                    setState(() {
                      _isLoading =
                          false; // Set _isLoading to false when loading ends
                    });
                  },
                  splashRadius: 15,
                  icon: Icon(
                    FlutterRemix.magic_line,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                    size: 20,
                  ),
                ),
        ),
      ],
    );
  }
}
