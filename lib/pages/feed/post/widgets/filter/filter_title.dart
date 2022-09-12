import 'package:flutter/material.dart';

class FilterTitle extends StatelessWidget {
  final String label;

  const FilterTitle({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: //top 10 botton 15
          const EdgeInsets.only(top: 25, bottom: 12, left: 15, right: 15),
      child: Text(label,
          //styl title small
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              )),
    );
  }
}
