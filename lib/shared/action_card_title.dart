import 'package:flutter/material.dart';

class ActionCardTitle extends StatelessWidget {
  final String title;

  const ActionCardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        title.toUpperCase(),
        //align left
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6),
            ),
      ),
    );
  }
}
