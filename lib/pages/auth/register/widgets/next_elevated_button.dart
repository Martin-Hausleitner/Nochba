import 'package:flutter/material.dart';
import 'package:nochba/pages/inset_post/new_post/new_post_controller.dart';

import '../../sign_up_controller.dart';

class NextElevatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool rtl;
  const NextElevatedButton({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.rtl = false,
  }) : super(key: key);

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        //right icon posission

        icon: Icon(icon),
        label: Text(
          label,
          style: Theme.of(context).textTheme.button?.copyWith(
                color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                letterSpacing: -0.07,
              ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(60),
          shadowColor: Colors.transparent,
          // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
