//create a filterchip which is around cintainer with a gray border and when cicked the border color changes to primary color and a check icon appears
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class FilterLabelChip extends StatelessWidget {
  const FilterLabelChip(
      {Key? key,
      required this.label,
      required this.isSelected,
      this.isIncluded = emptyFunction,
      required this.onTap})
      : super(key: key);

  final String label;
  // final CategoryOptions category;
  final bool Function() isSelected;
  final bool Function() isIncluded;
  final Function() onTap;

  static bool emptyFunction() => false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected()
                ? Theme.of(context).primaryColor
                : isIncluded()
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected())
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    FlutterRemix.check_line,
                    color: Theme.of(context).primaryColor,
                    size: 15,
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected()
                      ? Theme.of(context).primaryColor
                      : isIncluded()
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
