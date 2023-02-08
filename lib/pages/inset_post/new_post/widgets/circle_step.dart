import 'package:flutter/material.dart';

class CircleStep extends StatelessWidget {
  final num state;
  final String index;
  //add onTap
  final VoidCallback? onTap;

  const CircleStep(this.state, this.index, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        //if state is 1 the backroun dis gray
        //if state is 2 the background is transparent and it has a gray border
        //if state is 3 the background is green
        decoration: state == 1
            ? BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.09),
                borderRadius: BorderRadius.circular(50),
              )
            : state == 2
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.15),
                      width: 1,
                    ),
                  )
                : BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),

        child: Center(
          child: state == 1 || state == 2
              ? Text(index)
              : const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 23,
                ),
        ),
      ),
    );
  }
}
