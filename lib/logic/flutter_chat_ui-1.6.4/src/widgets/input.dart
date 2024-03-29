import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:nochba/logic/models/user.dart' as models;

import 'package:nochba/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart'
    as types;
import '../../../flutter_chat_types-3.4.5/src/messages/text_message.dart';
import '../models/input_clear_mode.dart';
import '../models/send_button_visibility_mode.dart';
import 'attachment_button.dart';
import 'inherited_chat_theme.dart';
import 'input_text_field_controller.dart';
import 'send_button.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

/// A class that represents bottom bar widget with a text field, attachment and
/// send buttons inside. By default hides send button when text field is empty.
class Input extends StatefulWidget {
  /// Creates [Input] widget.
  const Input({
    super.key,
    this.isAttachmentUploading,
    this.onAttachmentPressed,
    required this.onSendPressed,
    this.options = const InputOptions(),
    required this.items,
    this.localUserId,
  });

  // final List<Object> items;
  final List<types.Message> items;

  /// Whether attachment is uploading. Will replace attachment button with a
  /// [CircularProgressIndicator]. Since we don't have libraries for
  /// managing media in dependencies we have no way of knowing if
  /// something is uploading so you need to set this manually.
  final bool? isAttachmentUploading;

  /// See [AttachmentButton.onPressed].
  final VoidCallback? onAttachmentPressed;

  /// Will be called on [SendButton] tap. Has [types.PartialText] which can
  /// be transformed to [types.TextMessage] and added to the messages list.
  final void Function(types.PartialText) onSendPressed;

  /// Customisation options for the [Input].
  final InputOptions options;

  final String? localUserId;

  @override
  State<Input> createState() => _InputState();
}

/// [Input] widget state.
class _InputState extends State<Input> {
  late final _inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.enter &&
          !HardwareKeyboard.instance.physicalKeysPressed.any(
            (el) => <PhysicalKeyboardKey>{
              PhysicalKeyboardKey.shiftLeft,
              PhysicalKeyboardKey.shiftRight,
            }.contains(el),
          )) {
        if (event is KeyDownEvent) {
          _handleSendPressed();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  bool _sendButtonVisible = false;
  late TextEditingController _textController;

  SmartReplySuggestionResult? _suggestions;
  final SmartReply _smartReply = SmartReply();

  @override
  void initState() {
    super.initState();
    _textController =
        widget.options.textEditingController ?? InputTextFieldController();
    _textController.addListener(() {
      setState(() {
        _sendButtonVisible = _textController.text.trim().isNotEmpty;
      });
    });
    _generateSmartReplies();
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _generateSmartReplies();
    }
  }

  @override
  void dispose() {
    _smartReply.close();
    super.dispose();
  }

  Future<void> _generateSmartReplies() async {
    _smartReply.clearConversation();
    List<types.Message> reversedItems = widget.items.reversed.toList();
    for (types.Message message in reversedItems) {
      if (message is types.TextMessage) {
        final user = message.author;
        final timestamp = message.createdAt;
        if (widget.localUserId == user.id) {
          _smartReply.addMessageToConversationFromLocalUser(
            message.text,
            timestamp!,
          );
        } else {
          _smartReply.addMessageToConversationFromRemoteUser(
            message.text,
            timestamp!,
            user.id,
          );
          dev.log('Remote User ${user.role.toString()}: ${message.text}');
        }
      }
    }
    final result = await _smartReply.suggestReplies();
    setState(() {
      _suggestions = result;
    });

    // Log smart replies
    dev.log('Smart Replies: ${_suggestions?.suggestions}');

    // Log the first stored Smart Reply if available
    if (_suggestions != null && _suggestions!.suggestions.isNotEmpty) {
      dev.log('First Smart Reply: ${_suggestions!.suggestions.first}');
    } else {
      dev.log('No Smart Replies available.');
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _inputFocusNode.requestFocus(),
        child: _inputBuilder(),
      );

  void _handleSendButtonVisibilityModeChange() {
    _textController.removeListener(_handleTextControllerChange);
    if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.hidden) {
      _sendButtonVisible = false;
    } else if (widget.options.sendButtonVisibilityMode ==
        SendButtonVisibilityMode.editing) {
      _sendButtonVisible = _textController.text.trim() != '';
      _textController.addListener(_handleTextControllerChange);
    } else {
      _sendButtonVisible = true;
    }
  }

  void _handleSendPressed() {
    final trimmedText = _textController.text.trim();
    if (trimmedText != '') {
      final partialText = types.PartialText(text: trimmedText);
      widget.onSendPressed(partialText);

      if (widget.options.inputClearMode == InputClearMode.always) {
        _textController.clear();
      }
    }
  }

  void _handleTextControllerChange() {
    setState(() {
      _sendButtonVisible = _textController.text.trim() != '';
    });
  }

  Map<String, List<TextMessage>> groupMessagesByUser() {
    Map<String, List<TextMessage>> groupedMessages = {};

    for (var item in widget.items) {
      if (item is TextMessage) {
        String userId = item.author.id;

        if (!groupedMessages.containsKey(userId)) {
          groupedMessages[userId] = [];
        }
        groupedMessages[userId]!.add(item);
      }
    }

    return groupedMessages;
  }

  void printFirstNMessagesPerUser(int n) {
    Map<String, List<TextMessage>> groupedMessages = groupMessagesByUser();

    for (String userId in groupedMessages.keys) {
      List<TextMessage> messages = groupedMessages[userId]!;
      int messagesToPrint = n <= messages.length ? n : messages.length;

      print('Benutzer-ID: $userId');
      for (int i = 0; i < messagesToPrint; i++) {
        TextMessage message = messages[i];
        print('Nachricht ${i + 1}: ${message.text}');
      }
    }
  }

  Widget _buildChipList() {
    List<String> buttonTexts =
        _suggestions?.suggestions.map<String>((s) => s).toList() ?? [];

    return Container(
      padding: EdgeInsets.only(left: 5),
      height: 40,
      child: ListView.builder(
        itemCount: buttonTexts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: TextButton(
              onPressed: () {
                _textController.text = buttonTexts[index];
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                child: Text(
                  buttonTexts[index],
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _inputBuilder() {
    final query = MediaQuery.of(context);
    final buttonPadding = InheritedChatTheme.of(context)
        .theme
        .inputPadding
        .copyWith(left: 16, right: 16);
    final safeAreaInsets = kIsWeb
        ? EdgeInsets.zero
        : EdgeInsets.fromLTRB(
            query.padding.left,
            0,
            query.padding.right,
            query.viewInsets.bottom + query.padding.bottom,
          );
    final textPadding = const EdgeInsets.fromLTRB(0, 15, 10, 15)
        .copyWith(left: 0, right: 0)
        .add(
          const EdgeInsets.fromLTRB(
            // widget.onAttachmentPressed != null ? 0 : 10,
            10,
            0,
            // _sendButtonVisible ? 0 : 10,
            6,
            0,
          ),
        );

    return SafeArea(
      child: Column(
        children: [
          _buildChipList(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Focus(
              autofocus: true,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.onAttachmentPressed != null)
                                    AttachmentButton(
                                      isLoading:
                                          widget.isAttachmentUploading ?? false,
                                      onPressed: widget.onAttachmentPressed,
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 13.5, 5, 13.5),
                                    ),
                                  Expanded(
                                    child: Padding(
                                      padding: textPadding,
                                      child: Column(
                                        children: [
                                          TextField(
                                            autofocus: true,
                                            focusNode: _inputFocusNode,
                                            controller: _textController,
                                            cursorColor:
                                                InheritedChatTheme.of(context)
                                                    .theme
                                                    .inputTextCursorColor,
                                            decoration: InheritedChatTheme.of(
                                                    context)
                                                .theme
                                                .inputTextDecoration
                                                .copyWith(
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color!
                                                            .withOpacity(0.5),
                                                        fontSize: 15,
                                                      ),
                                                  hintText: 'Neue Nachricht',
                                                ),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 5,
                                            minLines: 1,
                                            onChanged:
                                                widget.options.onTextChanged,
                                            onTap:
                                                widget.options.onTextFieldTap,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _sendButtonVisible,
                                    child: GestureDetector(
                                      onTap: _handleSendPressed,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 6, 6, 6),
                                        child: SizedBox(
                                          height: 38.5,
                                          width: 38.5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.send,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class InputOptions {
  const InputOptions({
    this.inputClearMode = InputClearMode.always,
    this.onTextChanged,
    this.onTextFieldTap,
    this.sendButtonVisibilityMode = SendButtonVisibilityMode.editing,
    this.textEditingController,
    this.backgroundColor = Colors.transparent,
  });

  final InputClearMode inputClearMode;
  final void Function(String)? onTextChanged;
  final VoidCallback? onTextFieldTap;
  final SendButtonVisibilityMode sendButtonVisibilityMode;
  final TextEditingController? textEditingController;
  final Color backgroundColor;
}
