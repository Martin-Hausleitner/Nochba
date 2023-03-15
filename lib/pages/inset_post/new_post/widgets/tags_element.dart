import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:nochba/pages/inset_post/edit_post/edit_post_controller.dart';
import 'package:openai_client/openai_client.dart';

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
  }) : super(key: key);

  final List<String> tags;
  final Function(String tag) removeTag;
  final Function(BuildContext context) showTagDialog;
  final Function(String tag) addTag;
  final TextEditingController? descriptionController;

  @override
  State<TagsElement> createState() => _TagsElementState();
}

class _TagsElementState extends State<TagsElement> {
  bool _isLoading = false;
  Future<void> callOpenAI() async {
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

      //cheakc if widget.description is null
      if (widget.descriptionController!.text.isEmpty) {
        print(widget.descriptionController!.text);
        Get.snackbar(
            'Fehler', 'Bitte Füge ein Beschreibung zu dem Beitrag hinzu!');
        return;
      }

      final String prompt =
          'erstelle eine classification prompt für ein post: ${widget.descriptionController!.text}\n \n \n um 3 oder 4 oder 5 tags zu erstellen \n fromat 1. 2. 3. 4. 5. \n  benutze die sprache des text \n benutze nur Einwortbegriffe als Tag';
      final chat = await client.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          ChatMessage(
            role: 'user',
            content: prompt,
          )
        ],
      ).data;
      final chatOutput = chat.toString();
      setState(() {
        addTagsToWidget(chatOutput);
      });

      print(chat.toString());
    } catch (e, stackTrace) {
      print('Error calling OpenAI API: $e');
      print(stackTrace);
      Get.snackbar(
          'Fehler', 'Es ist ein Fehler bei der ausführung der Ki passiert: $e');
    }
  }

  List<String> parseTags(String chatOutput) {
    // Suche nach dem Muster: "1. Tag1\n2. Tag2\n3. Tag3\n4. Tag4\n5. Tag5"
    RegExp regExp = RegExp(r'(\d+\.\s[^\n]+)');
    Iterable<RegExpMatch> matches = regExp.allMatches(chatOutput);
    List<String> tags = [];

    for (RegExpMatch match in matches) {
      String tag = match
          .group(0)!
          .substring(3)
          .trim(); // Entferne die Zahl und das Leerzeichen am Anfang

      // Entferne unerwünschte Zeichen am Ende des letzten Tags
      int unwantedStart = tag.indexOf('),');
      if (unwantedStart > -1) {
        tag = tag.substring(0, unwantedStart).trim();
      }

      tags.add(tag);
      print(tags);
    }

    return tags;
  }

// Rufe diese Funktion auf, nachdem du die Antwort von OpenAI erhalten hast
  void addTagsToWidget(String chatOutput) {
    List<String> newTags = parseTags(chatOutput);
    for (String tag in newTags) {
      if (!widget.tags.contains(tag)) {
        widget.tags.add(tag);
      }
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
                        padding: const //top 8
                            EdgeInsets.only(top: 0),
                        child: Wrap(
                          //vertical padding
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
                      // Show the loading indicator when _isLoading is true
                      strokeWidth: 2.5,
                      // valueColor: AlwaysStoppedAnimation<Color>(
                      //   Theme.of(context)
                      //       .colorScheme
                      //       .onSurface
                      //       .withOpacity(0.5),
                      // ),
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
