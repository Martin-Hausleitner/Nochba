import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import 'filter_title.dart';

class FilterRangeSlider extends StatefulWidget {
  const FilterRangeSlider({super.key});

  @override
  State<FilterRangeSlider> createState() => _FilterRangeSliderState();
}

class _FilterRangeSliderState extends State<FilterRangeSlider> {
  double _currentSliderValue = 20;

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 5,
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
