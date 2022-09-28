import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/logic/models/post.dart' as models;
import 'package:locoo/logic/models/user.dart' as models;
import 'package:locoo/pages/feed/views/feed_post_filter_view.dart';
import 'package:locoo/pages/feed/widgets/post_card.dart';

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
            TestSlider(),
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

//create a gesturedector which triggers a overlayentry
class TestSlider extends StatefulWidget {
  const TestSlider({Key? key}) : super(key: key);

  @override
  _TestSliderState createState() => _TestSliderState();
}

class _TestSliderState extends State<TestSlider> {
  final GlobalKey _key = GlobalKey();
  late OverlayEntry _overlayEntry;
  double _currentSliderValue = 20;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _overlayEntry = _createOverlayEntry();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,

      // onTapDown show _toggleOverlay();
      onTapDown: (TapDownDetails details) {
        _toggleOverlay();
      },

      // onTapUp hide _toggleOverlay();

      onTapUp: (TapUpDetails details) {
        _toggleOverlay();
      },

      // onTapCancel: () {
      //   _toggleOverlay();
      // },

      child: Slider(
        value: _currentSliderValue,
        max: 100,
        divisions: 5,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 200,
          height: 200,
          child: Container(
            color: Colors.blue,
          ),
        );
      },
    );
  }

  void _toggleOverlay() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    print(offset);
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
    if (_isOverlayVisible) {
      Overlay.of(context)!.insert(_overlayEntry);
    } else {
      _overlayEntry.remove();
    }
  }
}

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
