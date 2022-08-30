import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

// create a stateless button with a text NEW and a background color of Colors.blue[100]
class LocooTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const LocooTextButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              // add primeryColor to the background
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
              // color: Colors.red,
            ),
          ),
          TextButton.icon(
            //   //set color to primeryColor

            // <-- TextButton
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 24.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),

            label: Text(
              text,
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                    letterSpacing: -0.07,
                  ),
            ),
            style: // add primeryColor to the text
                TextButton.styleFrom(
              //the minimumSize of the button is 100%
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}
