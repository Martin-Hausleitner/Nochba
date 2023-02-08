import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';

class TextFieldRemoveTextButton extends StatelessWidget {
  const TextFieldRemoveTextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: //top 20
          const EdgeInsets.only(top: 11, left: 2),
      child: LocooCircularIconButton(
        iconData: FlutterRemix.close_line,
        fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        radius: 20,
        onPressed: onPressed,
      ),
    );
  }
}
