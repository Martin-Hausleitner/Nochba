import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'filter_title.dart';

class FilterRangeSlider extends StatefulWidget {
  const FilterRangeSlider({super.key});

  @override
  State<FilterRangeSlider> createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  double _currentSliderValue = 20;
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterTitle(label: 'Reichweite'),
              Padding(
                padding: const EdgeInsets.only(
                    top: 25, bottom: 12, left: 15, right: 15),
                child: Text('${_currentSliderValue.round()}km'),
              ),
            ],
          ),
        ),
        // Test1(),
        // Example2(),
        //if focusnoed is active, show a text else a text with no
        // focusnode

        // if (_focusNode.hasFocus)
        //   Text('focusnode is active')
        // else
        //   Text('focusnode is not active'),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 5,
            focusNode: _focusNode,
            label: _currentSliderValue == 0
                ? 'eignes Haus'
                : '${_currentSliderValue.round()}',
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
        // Test(),
        Padding(
          padding: //left right 20
              const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            // space between the two icons
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                FlutterRemix.home_2_line,
              ),
              Text('200m'),
              SizedBox(
                width: 40,
              ),
              Text('1km'),
              SizedBox(
                width: 30,
              ),
              Text('20km'),
            ],
          ),
        ),
      ],
    );
  }
}

//Create a widget called Test1 which show Overlay on the screen when the FocusNode is focused.
class Test1 extends StatefulWidget {
  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _focusNode,
        ),
        OutlinedButton(
          onPressed: () {
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            } else {
              FocusScope.of(context).requestFocus(_focusNode);
            }
          },
          child: Text('Toggle Focus'),
        ),
        // if (_focusNode.hasFocus)
        //   Positioned(

        //     child: Container(
        //       color: Colors.red.withOpacity(0.5),
        //     ),
        //   ),
      ],
    );
  }
}

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  _Example2State createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  void _showOverlay(BuildContext context) async {
    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      // You can return any widget you like
      // here to be displayed on the Overlay
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.2,
        top: MediaQuery.of(context).size.height * 0.3,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              Image.asset(
                'images/commentCloud.png',
                colorBlendMode: BlendMode.multiply,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                left: MediaQuery.of(context).size.width * 0.13,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'I will disappear in 3 seconds.',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    // Inserting the OverlayEntry into the Overlay
    overlayState?.insert(overlayEntry);

    // Awaiting for 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // Removing the OverlayEntry from the Overlay
    overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        color: Colors.green,
        minWidth: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.06,
        child: Text(
          'show Overlay',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          // calling the _showOverlay method
          // when Button is pressed
          _showOverlay(context);
        },
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late TextEditingController _controller;
  FocusNode _focusNode = FocusNode();
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // FocusScope.of(context).requestFocus(_focusNode);
      showOverlay();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0,
        width: size.width,
        child: buildOverlay(),
      ),
    );

    overlay?.insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return //textfield
        TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Name',
      ),
    );
  }
}

Widget buildOverlay() {
  return Column(
    children: [
      Container(
        // height: 10,
        color: Colors.red.withOpacity(0.1),
      ),
      Container(
        // height: 10,
        color: Colors.green.withOpacity(0.1),
      ),
    ],
  );
}
