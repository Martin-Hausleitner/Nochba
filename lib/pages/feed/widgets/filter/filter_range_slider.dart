import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import 'filter_title.dart';

class FilterRangeSlider extends StatefulWidget {
  const FilterRangeSlider({super.key});

  // final double sliderValue;
  // final Function(double) onChanged;

  @override
  State<FilterRangeSlider> createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  double _currentSliderValue = 20;
  OverlayEntry? _overlayEntry;
  var bottomSheetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: bottomSheetKey,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              FilterTitle(label: 'Reichweite'),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 25, bottom: 12, left: 15, right: 15),
              //   child: Text('${_currentSliderValue.round()}km'),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 5,
            label: _currentSliderValue == 0
                ? 'eignes Haus'
                : '${_currentSliderValue.round()}',
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
            // onChangeStart: (double value) {
            //   showOverlay();
            // },
            // onChangeEnd: (double value) {
            //   hideOverlay();
            // },
          ),
        ),
        // Test(),
        Padding(
          padding: //left right 20
              const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            // space between the two icons
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
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



  // void showOverlay() {
  //   _overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       // top: 100,
  //       left: 15,
  //       //bottom size of bottomsheet
  //       bottom: bottomSheetKey.currentContext!.size!.height + 20,

  //       child: Container(
  //         width: //infinity width
  //             //size width screen
  //             MediaQuery.of(context).size.width - 30,
  //         height: 200,
  //         //add round corners
  //         // color: Colors.white,
  //         decoration: BoxDecoration(
  //           // color: Colors.white,
  //           color: Colors.white,

  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         //show as a child a  photo: C:\Users\am\.temp\lol\Locoo\assets\images\range.png with round corners
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(15),
  //           child: Image.asset(
  //             'assets/images/range.png',
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   Overlay.of(context)!.insert(_overlayEntry!);
  // }

  // create a function hideOverlay which removes the overlayEntry from the overlay

  // void hideOverlay() {
  //   _overlayEntry!.remove();
  //   _overlayEntry = null;
  // }

  // // create a function toggleOverlay which checks if the overlayEntry is null and if so calls showOverlay, otherwise calls hideOverlay

  // void toggleOverlay() {
  //   if (_overlayEntry == null) {
  //     showOverlay();
  //   } else {
  //     hideOverlay();
  //   }
  // }

