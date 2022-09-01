import 'package:flutter/material.dart';
import 'package:locoo/pages/new_post/new_post_controller.dart';

class PublishButton extends StatelessWidget {
  const PublishButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewPostController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => controller.addPost(),
      icon: const Icon(Icons.check),
      label: Text(
        'Veröffentlichen',
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
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
