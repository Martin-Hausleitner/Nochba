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
            spacing: 5,
            runSpacing: 5,
            children: [
              //print 10 buton
              FilterChip(
                label: 'Alle',
                selected: true,
              ),
              //show filterchips with: Mitteilung, Suche, Events, Ausleihen, Frage, Warnung, Empfehlung, Gefunden, Hilfe, Verloren
              FilterChip(
                label: 'Mitteilung',
              ),
              FilterChip(
                label: 'Suche',
              ),
              FilterChip(
                label: 'Ausleihen',
              ),
              FilterChip(
                label: 'Events',
              ),
              FilterChip(
                label: 'Frage',
              ),
              FilterChip(
                label: 'Warnung',
              ),
              FilterChip(
                label: 'Empfehlung',
              ),
              FilterChip(
                label: 'Gefunden',
              ),
              FilterChip(
                label: 'Hilfe',
              ),
              FilterChip(
                label: 'Verloren',
              ),
            ],
          ),
        ),
        FilterTitle(label: 'Sotieren nach'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              FilterChip(
                label: 'Neuste',
                selected: true,
              ),
              FilterChip(
                label: 'Meisten likes',
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

//create a filterchip which is around cintainer with a gray border and when cicked the border color changes to primary color and a check icon appears
class FilterChip extends StatelessWidget {
  const FilterChip({
    Key? key,
    required this.label,
    this.selected = false,
  }) : super(key: key);

  final String label;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selected
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  FlutterRemix.check_line,
                  color: Theme.of(context).primaryColor,
                  size: 15,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
