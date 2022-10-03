import 'package:flutter/material.dart';

class NewPostTitle extends StatelessWidget {
  final String label;

  const NewPostTitle({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: //top 10 botton 15
          const EdgeInsets.only(top: 25, bottom: 12, left: 0, right: 0),
      child: Text(label,
          //styl title small
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              )),
    );
  }
}
