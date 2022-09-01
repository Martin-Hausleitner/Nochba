import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  final bool isFinished;
  ProgressLine({this.isFinished = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: //horenzontal 4
            const EdgeInsets.symmetric(horizontal: 10),
        child: isFinished
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 1.2,
                color: Theme.of(context).primaryColor,
              )
            : DottedLine(
                lineThickness: 1.2,
                dashColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                // strokeWidth: 1,
                // color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                // dotSpacing: 5,
                // dotRadius: 2,
              ),
      ),
    );
  }
}
