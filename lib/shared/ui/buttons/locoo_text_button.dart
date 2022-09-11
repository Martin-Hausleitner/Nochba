import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

// create a stateless button with a text NEW and a background color of Colors.blue[100]
class LocooTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final double height;

  const LocooTextButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.icon,
      this.height = 60});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
              letterSpacing: 0.00,
              fontWeight: FontWeight.w500,
            ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size.fromHeight(height),
        shadowColor: Colors.transparent,
        // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(140),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(14),
    //   child: Stack(
    //     children: <Widget>[
    //       Positioned.fill(
    //         child: Container(
    //           // add primeryColor to the background
    //           color: Theme.of(context).buttonTheme.colorScheme?.primary,
    //           // color: Colors.red,
    //         ),
    //       ),
    //       TextButton.icon(
    //         //   //set color to primeryColor

    //         // <-- TextButton
    //         // add to onPressed HapticFeedback.lightImpact(); and onPressed
    //         onPressed: () {
    //           HapticFeedback.lightImpact();
    //           onPressed();
    //         },

    //         icon: Icon(
    //           icon,
    //           size: 24.0,
    //           color: Theme.of(context).colorScheme.onPrimary,
    //         ),

    //         label: Text(
    //           text,
    //           style: Theme.of(context).textTheme.button?.copyWith(
    //                 color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
    //                 letterSpacing: -0.07,
    //               ),
    //         ),
    //         style: // add primeryColor to the text
    //             TextButton.styleFrom(
    //           //the minimumSize of the button is 100%
    //           minimumSize: const Size.fromHeight(50),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class SimpleElevatedButtonWithIcon extends StatelessWidget {
  const SimpleElevatedButtonWithIcon(
      {required this.label,
      this.color,
      this.iconData,
      required this.onPressed,
      this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      Key? key})
      : super(key: key);
  final Widget label;
  final Color? color;
  final IconData? iconData;
  final Function onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed as void Function()?,
      icon: Icon(iconData),
      label: label,
      style: ElevatedButton.styleFrom(primary: color, padding: padding),
    );
  }
}
