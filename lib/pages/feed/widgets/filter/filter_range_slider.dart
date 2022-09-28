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

// crate a new sate widget slidertest which shows a container when the slider moves



