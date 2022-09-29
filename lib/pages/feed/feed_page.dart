import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/models/post.dart' as models;
import 'package:locoo/logic/models/user.dart' as models;
import 'package:locoo/pages/feed/views/feed_post_filter_view.dart';
import 'package:locoo/pages/feed/widgets/post_card.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../shared/range_slider/range_slider.dart';
import 'feed_controller.dart';

class FeedPage extends GetView<FeedController> {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
          children: [
            // TestSlider(),
            // Test2(),

            // LocooRangeSlider(),
            ElevatedButton(
              child: const Text('Filter1'),
              // onPressed: () {
              //   showModalBottomSheet<void>(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return FeedPostFilterView();
              //     },
              //   );
              // },
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0))),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return FeedPostFilterView();
                  },
                );
              },
            ),

            Expanded(
              child: StreamBuilder<List<models.Post>>(
                stream: controller.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('The feeds are not available at the moment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w300)));
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!;

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts.elementAt(index);

                        return FutureBuilder<models.User?>(
                          future: controller.getUser(post.user),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              final user = snapshot.data!;
                              return Post(
                                post: post,
                                postAuthorName:
                                    '${user.firstName} ${user.lastName}',
                                postAuthorImage: user.imageUrl!,
                              );
                            } else {
                              return Container();
                            }
                          }),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 3),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                    // return const Text('There are no posts in the moment',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// //create state class Test2
// class Test2 extends StatefulWidget {
//   const Test2({Key? key}) : super(key: key);

//   @override
//   _Test2State createState() => _Test2State();
// }

// //create a silder which opens a overlay on start once and onChaneeEnd hide the overlay
// class _Test2State extends State<Test2> {
//   double _value = 0.0;
//   bool _isOverlayVisible = true;
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     _overlayEntry = _createOverlayEntry();
//     Overlay.of(context)!.insert(_overlayEntry!);
//   }

//   @override
//   void dispose() {
//     _overlayEntry!.remove();
//     super.dispose();
//   }

//   OverlayEntry _createOverlayEntry() {
//     return OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: 0,
//         left: 0,
//         right: 0,
//         child: Container(
//           height: 100,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Slider(
//       value: _value,
//       onChanged: (value) {
//         setState(() {
//           _value = value;
//         });
//       },
//       onChangeEnd: (value) {
//         setState(() {
//           _isOverlayVisible = false;
//         });
//       },
//     );
//   }
// }


  

  
     

  


// class _Test2State extends State<Test2> {
//   double _value = 20;
//   String _status = 'idle';
//   Color _statusColor = Colors.amber;
//   OverlayEntry? _overlayEntry;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Slider(
//           min: 0.0,
//           max: 100.0,
//           value: _value,
//           divisions: 10,
//           onChanged: (value) {
//             setState(() {
//               _value = value;
//               _status = 'active (${_value.round()})';
//               _statusColor = Colors.green;
//               // _showOverlay();
//               // _showOverlay();
//             });
//           },
//           onChangeStart: (value) {
//             setState(() {
//               _status = 'start';
//               _statusColor = Colors.lightGreen;
//             });
//           },
//           onChangeEnd: (value) {
//             setState(() {
//               _status = 'end';
//               _statusColor = Colors.red;
//               // _hideOverlay();
//             });
//           },
//         ),
//         Text(
//           'Status: $_status',
//           style: TextStyle(color: _statusColor),
//         ),
//       ],
//     );
//   }

//   //green overlay which shows up when slider is moved

  
// }

//class stateTest2 with a gesture detector with all fuctions if called the print the dunction name on top of a button which print a text
// class Test2 extends StatefulWidget {
//   const Test2({Key? key}) : super(key: key);

//   @override
//   _Test2State createState() => _Test2State();
// }

// class _Test2State extends State<Test2> {
//     double _currentSliderValue = 20;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print('onTap');
//       },
//       onTapDown: (TapDownDetails details) {
//         print('onTapDown');
//       },
//       onTapUp: (TapUpDetails details) {
//         print('onTapUp');
//       },
//       onTapCancel: () {
//         print('onTapCancel');
//       },
//       onDoubleTap: () {
//         print('onDoubleTap');
//       },
//       onLongPress: () {
//         print('onLongPress');
//       },
//       // onLongPressStart: (LongPressStartDetails details) {
//       //   print('onLongPressStart');
//       // },
//       // onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
//       //   print('onLongPressMoveUpdate');
//       // },
//       // onLongPressUp: () {
//       //   print('onLongPressUp');
//       // },
//       // onLongPressEnd: (LongPressEndDetails details) {
//       //   print('onLongPressEnd');
//       // },

//       onPanDown: (DragDownDetails details) {
//         print('onPanDown');
//       },
//       onPanStart: (DragStartDetails details) {
//         print('onPanStart');
//       },
//       onPanUpdate: (DragUpdateDetails details) {
//         print('onPanUpdate');
//       },
//       onPanEnd: (DragEndDetails details) {
//         print('onPanEnd');
//       },
//       onPanCancel: () {
//         print('onPanCancel');
//       },
//       // onScaleStart: (ScaleStartDetails details) {
//       //   print('onScaleStart');
//       // },
//       // onScaleUpdate: (ScaleUpdateDetails details) {
//       //   print('onScaleUpdate');
//       // },
//       child: Container(
//         width: double.infinity,
//         height: 100,
//         color: Colors.red,
//         child: Center(
//           //show a slider with value
//           child: Slider(
//             value: _currentSliderValue,
//             max: 100,
//             divisions: 5,
//             label: _currentSliderValue.round().toString(),
//             onChanged: (double value) {
//               setState(() {
//                 _currentSliderValue = value;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Test2 extends StatelessWidget {
//   const Test2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double _currentSliderValue = 20;
//     return GestureDetector(
//       onTap: () {
//         print('onTap');
//       },
//       onDoubleTap: () {
//         print('onDoubleTap');
//       },
//       onLongPress: () {
//         print('onLongPress');
//       },

//       onPanDown: (details) {
//         print('onPanDown');
//       },
//       onPanStart: (details) {
//         print('onPanStart');
//       },
//       onPanUpdate: (details) {
//         print('onPanUpdate');
//       },
//       onPanEnd: (details) {
//         print('onPanEnd');
//       },

//       //create a red box with a small button inside
//       //show a container with full width
//       child: Container(
//         width: double.infinity,
//         height: 100,
//         color: Colors.red,
//         child: Center(
//           //show a slider with value
//           child: Slider(
//             value: _currentSliderValue,
//             max: 100,
//             divisions: 5,
//             label: _currentSliderValue.round().toString(),
//             onChanged: (double value) {
//               setState(() {
//                 _currentSliderValue = value;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// create a class Test1 which has a gesture detector and a red container inside and when ontopdown on ontapup is called it will show a texet ontapdown

//create a overlayentry which show a blue box in the center of the screen with open and close function

// class Test2 extends StatefulWidget {
//   const Test2({Key? key}) : super(key: key);

//   @override
//   _Test2State createState() => _Test2State();
// }

// class _Test2State extends State<Test2> {
//   OverlayEntry? _overlayEntry;
//   double _value = 20;

//   @override
//   Widget build(BuildContext context) {
//     // return ElevatedButton(
//     //   onPressed: () {
//     //     open();
//     //   },
//     //   child: const Text('open'),
//     // );
//     return Container(
//       // color: Colors.pink,
//       height: 100,
//       width: 300,
//       child: GestureDetector(
//         // onPanDown: (details) {
//         //   //open overlay
//         //   open();
//         //   //show overlay
//         //   print('onpaddown1');
//         // },
//         // onPanUpdate: (details) {
//         //   print('onpanupdate1');
//         // },
//         // onPanEnd: (details) {
//         //   // close();
//         //   //print
//         //   print('onpanend');
//         // },
//         // onTapUp: (details) {
//         //   // close();
//         //   print('ontapup');
//         // },
//         // onTapDown: (details) {
//         //   // open();
//         //   print('ontapdown');
//         // },
//         // onTapCancel: () {
//         //   // close();
//         //   print('ontapcancel');
//         // },
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.red,
//               child: GestureDetector(
//                   // onTapDown: (details) {
//                   //   print('ontapdown');
//                   // },
//                   // onTapUp: (details) {
//                   //   print('ontapup');
//                   // },
//                   //if the courser is out of the box print out of container
//                   // onPanDown: (details) {
//                   //   open();
//                   //   //open overlay
//                   //   //show overlay
//                   //   print('onpaddown');
//                   // },
//                   onPanUpdate: (details) {
//                     print('onpanupdate');
//                   },
//                   // onPanEnd: (details) {
//                   //   close();
//                   //   //print
//                   //   print('onpanend');
//                   // },
//                   // //ontap
//                   // onTap: () {
//                   //   print('ontap');
//                   // },
//                   // child:
//                   ),
//             ),
//             Container(
//               height: 50,
//               color: Colors.green.withOpacity(0.5),
//               child: SfSlider(
//                 min: 0.0,
//                 max: 100.0,
//                 value: _value,
//                 interval: 20,
//                 showTicks: true,
//                 showLabels: true,
//                 enableTooltip: true,
//                 minorTicksPerInterval: 1,
//                 onChanged: (dynamic value) {
//                   setState(() {
//                     _value = value;
//                   });
//                 },
//               ),
//               // child: Slider(
//               //   value: _currentSliderValue,
//               //   max: 100,
//               //   divisions: 5,
//               //   label: _currentSliderValue.round().toString(),
//               //   onChanged: (double value) {
//               //     setState(() {
//               //       _currentSliderValue = value;
//               //     });
//               //   },
//               // ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //show overlay and close it after 2 seconds
//   void open() {
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: 0,
//         right: 0,
//         bottom: 0,
//         child: Container(
//           height: 100,
//           color: Colors.blue.withOpacity(0.5),
//         ),
//       ),
//     );
//     Overlay.of(context)!.insert(_overlayEntry!);
//     Future.delayed(const Duration(seconds: 1), () {
//       close();
//     });
//   }

//   void close() {
//     _overlayEntry?.remove();
//   }

//   // void open() {
//   //   _overlayEntry = OverlayEntry(
//   //     builder: (context) {
//   //       // return a small grenn container on the bottom of the button
//   //       return Positioned(
//   //         bottom: 0,
//   //         left: 0,
//   //         right: 0,
//   //         child: Container(
//   //           height: 100,
//   //           width: 100,
//   //           color: Colors.green,
//   //         ),
//   //       );
//   //     },
//   //   );
//   //   Overlay.of(context)!.insert(_overlayEntry!);

//   //   Future.delayed(const Duration(milliseconds: 100), () {
//   //     _overlayEntry!.remove();
//   //   });
//   // }

//   // void close() {
//   //   _overlayEntry!.remove();
//   // }
//   //close 0verley after 0.1 sec
//   // void close() {
//   //   Future.delayed(const Duration(milliseconds: 100), () {
//   //     _overlayEntry!.remove();
//   //   });
//   // }
// }

//create a gesturedector which triggers a overlayentry
// class TestSlider extends StatefulWidget {
//   const TestSlider({Key? key}) : super(key: key);

//   @override
//   _TestSliderState createState() => _TestSliderState();
// }

// class _TestSliderState extends State<TestSlider> {
//   final GlobalKey _key = GlobalKey();
//   late OverlayEntry _overlayEntry;
//   double _currentSliderValue = 20;
//   bool _isOverlayVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     _overlayEntry = _createOverlayEntry();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: _key,

//       // onTapDown show _toggleOverlay();
//       onTapDown: (TapDownDetails details) {
//         _toggleOverlay();
//         _isOverlayVisible = false;
//       },

//       // onTapUp hide _toggleOverlay();

//       // onTapUp: (TapUpDetails details) {
//       //   _toggleOverlay();
//       // },

//       // onTapCancel: () {
//       //   _toggleOverlay();
//       // },

//       // child: Slider(
//       //   value: _currentSliderValue,
//       //   max: 100,
//       //   divisions: 5,
//       //   label: _currentSliderValue.round().toString(),
//       //   onChanged: (double value) {
//       //     setState(() {
//       //       _currentSliderValue = value;
//       //     });
//       //   },
//       // ),

//       child: Container(
//         height: 50,
//         width: 200,
//         color: Colors.red,
//       ),
//     );
//   }

//   OverlayEntry _createOverlayEntry() {
//     return OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           width: 200,
//           height: 200,
//           child: Container(
//             color: Colors.blue,
//           ),
//         );
//       },
//     );
//   }

//   void _toggleOverlay() {
//     final RenderBox renderBox =
//         _key.currentContext!.findRenderObject() as RenderBox;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     print(offset);
//     setState(() {
//       _isOverlayVisible = !_isOverlayVisible;
//     });
//     if (_isOverlayVisible) {
//       Overlay.of(context)!.insert(_overlayEntry);
//     } else {
//       _overlayEntry.remove();
//     }
//   }
// }

//create a class stateful test1 which has a blue container with a gesture detector and when onTapDown then pops up a red overlay

// class Test1 extends StatefulWidget {
//   const Test1({Key? key}) : super(key: key);

//   @override
//   _Test1State createState() => _Test1State();
// }

// class _Test1State extends State<Test1> {
//   bool _showOverlay = false;

//   @override
//   Widget build(BuildContext context) {
//     // return Stack(
//     //   children: [
//     //     Container(
//     //       color: Colors.blue,
//     //       child: GestureDetector(
//   onTapDown: (details) {
//     setState(() {
//       _showOverlay = true;
//       //print test
//       print('test');
//     });
//   },
//   onTapUp: (details) {
//     setState(() {
//       _showOverlay = false;
//     });
//   },
//   onTapCancel: () {
//     setState(() {
//       _showOverlay = false;
//     });
//   },
// ),
//     //     ),
//     //     if (_showOverlay)
//     //       Positioned.fill(
//     //         child: Container(
//     //           color: Colors.red,
//     //         ),
//     //       ),
//     //   ],
//     // );
//   }
// }

//create testsilder which has a gesture detector and when onTap triggers OverlayEntryWidget

// void showOverlay(BuildContext context) {
//   OverlayEntry overlayEntry;
//   overlayEntry = OverlayEntry(
//     builder: (context) => Positioned(
//       top: 100,
//       left: 100,
//       child: Material(
//         color: Colors.transparent,
//         child: Container(
//           height: 200,
//           width: 200,
//           color: Colors.red,
//           child: Center(
//             child: Text('Overlay'),
//           ),
//         ),
//       ),
//     ),
//   );

//   Overlay.of(context)!.insert(overlayEntry);

//   Future.delayed(Duration(seconds: 1), () {
//     overlayEntry.remove();
//   });
// }

// //create a class which is a slider which onchange triggers a overlay with a text
// class LocooRangeSlider extends StatefulWidget {
//   const LocooRangeSlider({Key? key}) : super(key: key);

//   @override
//   _LocooRangeSliderState createState() => _LocooRangeSliderState();
// }

// class _LocooRangeSliderState extends State<LocooRangeSlider> {
//   RangeValues _currentRangeValues = const RangeValues(0, 100);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         RangeSlider(
//           values: _currentRangeValues,
//           min: 0,
//           max: 100,
//           divisions: 100,
//           labels: RangeLabels(
//             _currentRangeValues.start.round().toString(),
//             _currentRangeValues.end.round().toString(),
//           ),
//           onChanged: (RangeValues values) {
//             setState(() {
//               _currentRangeValues = values;
//             });
//             showOverlay(context);
//           },
//         ),
//         Text(
//             'Value: ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}'),
//       ],
//     );
//   }
// }
