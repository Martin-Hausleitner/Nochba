import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/inset_post/new_post/new_post_controller.dart';

class BackOutlinedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const BackOutlinedButton({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        primary: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // splashFactory: InkRipple.splashFactory,
        // enableFeedback: true,
      ),
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      label: Text(
        label,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.07,
            ),
      ),
      onPressed: () async {
        // controller.jumpBack();
        await controller.previousPage();
        HapticFeedback.lightImpact();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
