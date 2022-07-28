// create a PostButton class that extends StatelessWidget which contains a IconButton

import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  // Icon
  final IconData icon;
  final Color iconColor;

  const RoundIconButton({
    Key? key,
    required this.icon,
    this.iconColor = Colors.black,
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
      child: Icon(
        icon,
        color: iconColor,
        size: 18,
      ),
    );
  }
}

// create a PostButton 2 extents state with aButton which change to Red when pressed
