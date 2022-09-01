// create a scaffold with a pageview
// add a pageview to the scaffold

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:locoo/pages/chats/util.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          //align start
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post erstellen',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    // color: Theme.of(context).colorScheme.onSecondaryContainer,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
            SizedBox(height: 28),
            Row(
              children: [
                StateCircleStep(
                  state: 1,
                  index: 1,
                ),
                Spacer(),
                StateCircleStep(
                  state: 2,
                  index: 2,
                ),
                Spacer(),
                StateCircleStep(
                  state: 3,
                  index: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//create a cirele with a number on it with a state ture false and when its ture it will be a check mark and the background green
class StateCircleStep extends StatefulWidget {
  final num state;
  final int index;
  //add onTap
  final VoidCallback? onTap;
  const StateCircleStep(
      {Key? key, required this.state, this.onTap, this.index = 1})
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
        width: 35,
        height: 35,
        //if state is 1 the backroun dis gray
        //if state is 2 the background is transparent and it has a gray border
        //if state is 3 the background is green
        decoration: widget.state == 1
            ? BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.09),
                borderRadius: BorderRadius.circular(50),
              )
            : widget.state == 2
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
          child: widget.state == 1 || widget.state == 2
              ? Text(widget.index.toString())
              : Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 23,
                ),
        ),
      ),
    );
  }
}
