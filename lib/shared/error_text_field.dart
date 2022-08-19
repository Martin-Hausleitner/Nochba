import 'package:flutter/material.dart';

class ErrorTextField extends StatelessWidget {
  final String text;
  final double padding;
  const ErrorTextField({Key? key, required this.text, this.padding = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      color: const Color.fromARGB(255, 255, 153, 145),
      child: Center(child: Text(text)),
    );
  }
}