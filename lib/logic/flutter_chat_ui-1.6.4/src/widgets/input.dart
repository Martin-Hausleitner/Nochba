import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nochba/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart'
    as types;

import '../../../flutter_chat_types-3.4.5/src/messages/text_message.dart';
import '../models/input_clear_mode.dart';
import '../models/send_button_visibility_mode.dart';
import 'attachment_button.dart';
import 'inherited_chat_theme.dart';
import 'input_text_field_controller.dart';
import 'send_button.dart';

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
  });

  final List<Object> items;

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

  @override
  void initState() {
    super.initState();

    _textController =
        widget.options.textEditingController ?? InputTextFieldController();
    _handleSendButtonVisibilityModeChange();
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.sendButtonVisibilityMode !=
        oldWidget.options.sendButtonVisibilityMode) {
      _handleSendButtonVisibilityModeChange();
    }
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _textController.dispose();
    super.dispose();
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
    print(widget.items.toString());
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
      child: Padding(
        padding: // left 8 right 8 bottom 8
            const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Focus(
          autofocus: true,
          child: Material(
            // borderRadius: InheritedChatTheme.of(context).theme.inputBorderRadius,
            // color: Theme.of(context).scaffoldBackgroundColor,
            color: Colors.transparent,

            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          // height: 50,
                          // round corners
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            // color: Theme.of(context).scaffoldBackgroundColor,
                            color: Colors.red
                          ),

                          child: Row(
                            //alling bottom
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
                                  padding: // top 20 left 20 right 20 bottom 20
                                      textPadding,
                                  child: Column(
                                    children: [
                                      TextField(
                                        autofocus: true,
                                        //focus the texfield without the keyboard
                                        focusNode: _inputFocusNode,
                                        controller: _textController,
                                        cursorColor:
                                            InheritedChatTheme.of(context)
                                                .theme
                                                .inputTextCursorColor,
                                        decoration:
                                            InheritedChatTheme.of(context)
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
                                                  // hintText: InheritedL10n.of(context)
                                                  //     .l10n
                                                  //     .inputPlaceholder,
                                                  hintText: 'Neue Nachricht',
                                                ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        minLines: 1,
                                        onChanged: widget.options.onTextChanged,
                                        onTap: widget.options.onTextFieldTap,
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

                              ElevatedButton(
                                onPressed: () {
                                  print(widget.items.toString());

                                  for (var item in widget.items) {
                                    if (item is TextMessage) {
                                      if (item.text == 'sdsd') {
                                        print('Gefundener Wert: ${item.text}');
                                      }
                                    }
                                  }

                                  if (widget.items.isNotEmpty) {
                                    TextMessage lastMessage =
                                        widget.items.last as TextMessage;
                                    print(
                                        'Letzte Nachricht: ${lastMessage.text}');
                                  } else {
                                    print('Keine Nachrichten gefunden.');
                                  }

                                  int messagesToPrint = 3 <= widget.items.length
                                      ? 3
                                      : widget.items.length;
                                  for (int i = 0; i < messagesToPrint; i++) {
                                    TextMessage message =
                                        widget.items[i] as TextMessage;
                                    print(
                                        'Nachricht ${i + 1}: ${message.text}');
                                  }
                                  Map<String, List<TextMessage>>
                                      groupedMessages = groupMessagesByUser();
                                  printFirstNMessagesPerUser(3);

                                  // Gruppieren der Nachrichten und Anzeigen der ersten 3 Nachrichten pro Benutzer
                                },
                                child: Text('test'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(10),
                                ),
                              ),

                              //chat send button
                              Visibility(
                                visible: _sendButtonVisible,
                                child: GestureDetector(
                                  onTap: _handleSendPressed,
                                  child: Padding(
                                    padding: // left 9 top 6 right 9 bottom 6
                                        const EdgeInsets.fromLTRB(0, 6, 6, 6),
                                    child: SizedBox(
                                      height: 38.5,
                                      width: 38.5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
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

                      //create a icon button with a primery background
                      // sdsd
                      // LocooCircularIconButton(
                      //   fillColor: Theme.of(context).primaryColor,
                      //   iconColor: Theme.of(context).colorScheme.onPrimary,

                      //   iconData: Icons.send,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            // child: Row(
            //   textDirection: TextDirection.ltr,
            //   children: [
            //     if (widget.onAttachmentPressed != null)
            //       AttachmentButton(
            //         isLoading: widget.isAttachmentUploading ?? false,
            //         onPressed: widget.onAttachmentPressed,
            //         padding: buttonPadding,
            //       ),

            //     ConstrainedBox(
            //       constraints: BoxConstraints(
            //         minHeight: buttonPadding.bottom + buttonPadding.top + 24,
            //       ),
            //       child: Visibility(
            //         visible: _sendButtonVisible,
            //         child: SendButton(
            //           onPressed: _handleSendPressed,
            //           padding: buttonPadding,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
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
  });

  /// Controls the [Input] clear behavior. Defaults to [InputClearMode.always].
  final InputClearMode inputClearMode;

  /// Will be called whenever the text inside [TextField] changes.
  final void Function(String)? onTextChanged;

  /// Will be called on [TextField] tap.
  final VoidCallback? onTextFieldTap;

  /// Controls the visibility behavior of the [SendButton] based on the
  /// [TextField] state inside the [Input] widget.
  /// Defaults to [SendButtonVisibilityMode.editing].
  final SendButtonVisibilityMode sendButtonVisibilityMode;

  /// Custom [TextEditingController]. If not provided, defaults to the
  /// [InputTextFieldController], which extends [TextEditingController] and has
  /// additional fatures like markdown support. If you want to keep additional
  /// features but still need some methods from the default [TextEditingController],
  /// you can create your own [InputTextFieldController] (imported from this lib)
  /// and pass it here.
  final TextEditingController? textEditingController;
}
