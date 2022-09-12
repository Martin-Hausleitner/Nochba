import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/pages/feed/post/widgets/filter/filter_range_slider.dart';
import 'package:locoo/pages/feed/post/widgets/filter/filter_title.dart';
import 'package:locoo/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';

class FeedPostFilterView extends StatelessWidget {
  const FeedPostFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        //align left
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: // top left right 15
                const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 35,
                ),
                Text(
                  'Filter',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                LocooCircularIconButton(
                  iconData: FlutterRemix.close_line,
                  fillColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  iconColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                  radius: 35,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
          )
          // Divider(),
        ],
      ),
    );
  }
}
