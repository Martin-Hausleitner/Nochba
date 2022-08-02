// create a PostButton class that extends StatelessWidget which contains a IconButton

import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  // Icon
  final IconData icon;
  final Color iconColor;

  // add onPressed
  final VoidCallback onPressed;

  const RoundIconButton({
    Key? key,
    required this.icon,
    this.iconColor = Colors.black,
    required this.onPressed,
  }) : super(key: key);
  //Create a Contianer with a gray thin broder and inside a IconButton with a Icon and a onPressed function
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 226, 226, 226),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
        onPressed: onPressed,
      ),
    );
    // return ElevatedButton(
    //   onPressed: () {},
    //   child: Icon(Icons.menu, color: Colors.black),
    //   style: ButtonStyle(
    //     shape: MaterialStateProperty.all(CircleBorder()),
    //     padding: MaterialStateProperty.all(EdgeInsets.all(8)),

    //     backgroundColor:
    //         MaterialStateProperty.all(Colors.transparent), // <-- Button color
    //     overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
    //       if (states.contains(MaterialState.pressed))
    //         return Colors.red; // <-- Splash color
    //     }),

    //   ),
    // );
    // ClipOval(
    //   child: Material(
    //     color: Colors.blue, // Button color
    //     child: InkWell(
    //       splashColor: Colors.red, // Splash color
    //       onTap: () {},
    //       child: Container(
    //         width: 34,
    //         height: 34,
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: const Color.fromARGB(255, 226, 226, 226),
    //             width: 1,
    //           ),
    //           borderRadius: BorderRadius.circular(20),
    //         ),
    //         child: Icon(
    //           icon,
    //           color: iconColor,
    //           size: 18,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}


// create a PostButton 2 extents state with aButton which change to Red when pressed
