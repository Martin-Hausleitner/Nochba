import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class LocooRangeSlider extends StatefulWidget {
  const LocooRangeSlider({super.key});

  @override
  State<LocooRangeSlider> createState() => _LocooRangeSliderState();
}

class _LocooRangeSliderState extends State<LocooRangeSlider> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reichweite',
                  //styl title small
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
              Text('${_currentSliderValue.round()}km'),
            ],
          ),
        ),
        Slider(
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
        Padding(
          padding: //left right 20
              const EdgeInsets.symmetric(horizontal: 22),
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
