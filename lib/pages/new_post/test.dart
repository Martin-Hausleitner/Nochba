// create a scaffold with a pageview
// add a pageview to the scaffold

import 'package:flutter/material.dart';

class NewPostPage extends StatelessWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          NewPostPage1(),
          // NewPostPage2(),
          // NewPostPage3(),
        ],
      ),
    );
  }
}

// NewPostPage1

class NewPostPage1 extends StatelessWidget {
  const NewPostPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          StateCircleStep(
            isfinished: true,
          ),
        ],
      ),
    );
  }
}

//create a cirele with a number on it with a state ture false and when its ture it will be a check mark and the background green
class StateCircleStep extends StatefulWidget {
  final num isfinished;
  //add onTap
  final VoidCallback? onTap;
  const StateCircleStep({Key? key, required this.isfinished, this.onTap})
      : super(key: key);

  @override
  _StateCircleStepState createState() => _StateCircleStepState();
}

class _StateCircleStepState extends State<StateCircleStep> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: widget.isfinished ? Colors.green : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: widget.isfinished
          if
              Icon(
                  Icons.check,
                  color: Colors.white,
                )
               Text(
                  '1',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}

