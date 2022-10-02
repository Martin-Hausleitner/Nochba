import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_title.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/views/bottom_sheet_title_close_view.dart';

class FeedPostFilterView extends StatelessWidget {
  const FeedPostFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(
      title: 'Filter',
      children: [
        FilterRangeSlider(),
        FilterTitle(label: 'Filtern nach Kategorie'),
        Padding(
          padding: //horizontal 15
              const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: -5,
            runSpacing: 5,
            children: [
              //print 10 buton
              for (var i = 0; i < 10; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text('Kateie $i'),
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
            ],
          ),
        ),
        FilterTitle(label: 'Sotieren nach'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: -5,
            runSpacing: 5,
            children: [
              //print 10 buton
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text('Kategorie $i'),
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: LocooTextButton(
            label: 'Anwenden',
            onPressed: () {},
            icon: FlutterRemix.check_line,
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

//create a class called test silder which show a container when the focusnode is active

