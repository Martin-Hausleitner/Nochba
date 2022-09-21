import 'package:flutter/material.dart';

import 'inherited_chat_theme.dart';
import 'inherited_l10n.dart';

/// A class that represents send button widget.
class SendButton extends StatelessWidget {
  /// Creates send button widget.
  const SendButton({
    super.key,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });

  /// Callback for send button tap event.
  final VoidCallback onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => ClipRRect(
    //round   
        borderRadius: BorderRadius.circular(50),
        child: Container(
          margin: InheritedChatTheme.of(context).theme.sendButtonMargin ??
              const EdgeInsetsDirectional.fromSTEB(
                0,
                0,
                8,
                0,
              ),
          color: Theme.of(context).primaryColor,
          // round decoration

          // round

          child: IconButton(
            constraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
            icon: InheritedChatTheme.of(context).theme.sendButtonIcon ??
                // Image.asset(
                //   'assets/icon-send.png',
                //   color: InheritedChatTheme.of(context).theme.inputTextColor,
                //   package: 'flutter_chat_ui',
                // ),
                Icon(
                  Icons.send,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
            onPressed: onPressed,
            padding: padding,
            splashRadius: 24,
            
          ),
        ),
      );
}
