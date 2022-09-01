import 'package:flutter/material.dart';

class LocooCircularIconButton extends StatelessWidget {
  final double radius;

  const LocooCircularIconButton({
    this.fillColor = Colors.transparent,
    required this.iconData,
    this.iconColor = Colors.blue,
    this.outlineColor = Colors.transparent,
    this.notificationFillColor = Colors.red,
    this.notificationCount,
    this.onPressed,
    this.radius = 48.0,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final Color fillColor;
  final Color outlineColor;
  final Color iconColor;
  final Color notificationFillColor;
  final int? notificationCount;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Ink(
          width: radius,
          height: radius,
          decoration: ShapeDecoration(
            color: fillColor,
            shape: CircleBorder(side: BorderSide(color: outlineColor)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: radius / 2,
            iconSize: radius / 2 + 3,
            icon: Icon(iconData, color: iconColor),
            splashColor: iconColor.withOpacity(.4),
            onPressed: onPressed as void Function()?,
          ),
        ),
        // if (notificationCount != null) ...[
        //   Positioned(
        //     top: radius / -14,
        //     right: radius / -14,
        //     child: Container(
        //       width: radius / 2.2,
        //       height: radius / 2.2,
        //       decoration: ShapeDecoration(
        //         color: notificationFillColor,
        //         shape: const CircleBorder(),
        //       ),
        //       child: Center(
        //         child: Text(
        //           notificationCount.toString(),
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: radius / 4,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }
}
