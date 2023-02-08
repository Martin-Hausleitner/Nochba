import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  final double paddingLeft;
  final double paddingRight;

  final bool isFinished;
  const ProgressLine(
      {super.key, this.isFinished = false,
      this.paddingLeft = 10.0,
      this.paddingRight = 10.0});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: //horenzontal 4
            EdgeInsets.only(left: paddingLeft, right: paddingRight),
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

class ProgressLineHalf extends StatelessWidget {
  final double paddingLeft;
  final double paddingRight;

  final bool isFinished;
  const ProgressLineHalf(
      {super.key, this.isFinished = false,
      this.paddingLeft = 10.0,
      this.paddingRight = 10.0});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: //horenzontal 4
              EdgeInsets.only(left: paddingLeft, right: paddingRight),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: DottedLine(
                  lineThickness: 1.2,
                  dashColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  // strokeWidth: 1,
                  // color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                  // dotSpacing: 5,
                  // dotRadius: 2,
                ),
              ),
            ],
          )),
    );
  }
}
