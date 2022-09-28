// create a PostButton class that extends StatelessWidget which contains a IconButton

import 'package:flutter/material.dart';

class LocooCircleIconButton extends StatelessWidget {
  // Icon
  final IconData icon;
  final bool? isPressed;

  // add onPressed
  final VoidCallback? onPressed;

  LocooCircleIconButton({
    super.key,
    required this.icon,
    this.isPressed = false,
    this.onPressed,
  });

  //Create a Contianer with a gray thin broder and inside a IconButton with a Icon and a onPressed function
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isPressed!
              ? Theme.of(context).primaryColor.withOpacity(0.3)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isPressed!
                ? Colors.transparent
                : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isPressed!
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onSurface,
          size: 18,
        ),
      ),
    );
  }
}


// create a PostButton 2 extents state with aButton which change to Red when pressed
