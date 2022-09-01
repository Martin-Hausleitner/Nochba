import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/pages/new_post/new_post_controller.dart';

class BackOutlinedButton extends StatelessWidget {
  const BackOutlinedButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewPostController controller;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        primary: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        // splashFactory: InkRipple.splashFactory,
        enableFeedback: true,
      ),
      icon: Icon(
        FlutterRemix.arrow_left_s_line,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      label: Text(
        'Zurück',
        style: Theme.of(context).textTheme.button?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.07,
            ),
      ),
      onPressed: () {
        controller.jumpBack();
        HapticFeedback.lightImpact();
      },
    );
  }
}
