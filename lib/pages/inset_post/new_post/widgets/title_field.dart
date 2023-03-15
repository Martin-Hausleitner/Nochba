import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:openai_client/openai_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

import '../new_post_controller.dart';

class TitleField extends StatefulWidget {
  const TitleField({
    Key? key,
    required this.controller,
    this.descriptionController,
    this.titleController,
  }) : super(key: key);

  final NewPostController controller;
  final TextEditingController? descriptionController;
  final TextEditingController? titleController;

  @override
  State<TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  bool _isLoading = false;
  Future<void> callOpenAI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int callCount = 0;
    await prefs.setInt('callOpenAI_count', callCount + 1);

    callCount = prefs.getInt('callOpenAI_count') ?? 0;
    int _maxCalls = 20;

    if (callCount == 0) {
      Get.snackbar('Info', 'Sie haben insgesamt 20 Aufrufe zur Verfügung.');
    } else if (callCount >= _maxCalls - 5 && callCount < _maxCalls) {
      Get.snackbar(
          'Info', 'Sie haben noch ${_maxCalls - callCount} Aufrufe übrig.');
    } else if (callCount >= _maxCalls) {
      Get.snackbar('Info', 'Sie haben keine Aufrufe mehr zur Verfügung.');
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
        Get.snackbar(
            'Fehler', 'Bitte Füge ein Beschreibung zu dem Beitrag hinzu!');
        return;
      }

      final String prompt =
          'beschreibung{ ${widget.descriptionController!.text} } passender Titel: ';
      final chat = await client.chat.create(
        model: 'gpt-3.5-turbo',
        // stream: true,
        messages: [
          ChatMessage(
            role: 'user',
            content: prompt,
          )
        ],
      ).data;

      final response = chat.choices[0].message.content;
      print(response);

      setState(() {
        String modifiedResponse = response;
        if (modifiedResponse.startsWith('"')) {
          modifiedResponse = modifiedResponse.substring(1);
        }
        if (modifiedResponse.endsWith('"')) {
          modifiedResponse =
              modifiedResponse.substring(0, modifiedResponse.length - 1);
        }
        widget.titleController!.text = modifiedResponse;
      });
      await prefs.setInt('callOpenAI_count', callCount + 1);
    } catch (e, stackTrace) {
      print('Error calling OpenAI API: $e');
      print(stackTrace);
      Get.snackbar(
          'Fehler', 'Es ist ein Fehler bei der Ausführung der KI passiert: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LocooTextField(
          controller: widget.controller.titleController,
          textInputAction: TextInputAction.next,
          label: 'Titel',
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) => value != null && value.isEmpty
              ? 'Geben Sie einen Titel ein'
              : null,
        ),
        Positioned(
          top: 0,
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
                      _isLoading = true;
                    });
                    await callOpenAI();
                    setState(() {
                      _isLoading = false;
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