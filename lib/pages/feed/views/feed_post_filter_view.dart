import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/PostFilter.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/pages/feed/feed_controller.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_chip.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_title.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/views/bottom_sheet_title_close_view.dart';

class FeedPostFilterView extends StatelessWidget {
  const FeedPostFilterView({super.key, required this.controller});

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(title: 'Filter', children: [
      //FilterRangeSlider(),
      FilterTitle(label: 'Filtern nach Kategorie'),
      Padding(
        padding: //horizontal 15
            const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<FeedController>(
          builder: (c) => Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              //print 10 buton
              FilterLabelChip(
                label: 'Alle',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.None),
                onTap: () => controller.selectFilterChip(CategoryOptions.None),
              ),
              const Divider(),
              FilterLabelChip(
                label: 'Mitteilung',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Message),
                isIncluded: () => controller.isFilterChipAsMainCategoryIncluded(
                    CategoryOptions.Message),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Message),
              ),
              const SizedBox(width: 10),
              FilterLabelChip(
                label: 'Frage',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Question),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Question),
              ),
              FilterLabelChip(
                label: 'Appell',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Appeal),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Appeal),
              ),
              FilterLabelChip(
                label: 'Warnung',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Warning),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Warning),
              ),
              FilterLabelChip(
                label: 'Empfehlung',
                isSelected: () => controller
                    .isFilterChipSelected(CategoryOptions.Recommendation),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Recommendation),
              ),
              FilterLabelChip(
                label: 'Gefunden',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Found),
                onTap: () => controller.selectFilterChip(CategoryOptions.Found),
              ),
              const Divider(),
              FilterLabelChip(
                label: 'Suche',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Search),
                isIncluded: () => controller
                    .isFilterChipAsMainCategoryIncluded(CategoryOptions.Search),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Search),
              ),
              const SizedBox(width: 10),
              FilterLabelChip(
                label: 'Hilfe',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Help),
                onTap: () => controller.selectFilterChip(CategoryOptions.Help),
              ),

              FilterLabelChip(
                label: 'Verloren',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Lost),
                onTap: () => controller.selectFilterChip(CategoryOptions.Lost),
              ),
              const Divider(),
              FilterLabelChip(
                label: 'Ausleihen',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Lending),
                isIncluded: () => controller.isFilterChipAsMainCategoryIncluded(
                    CategoryOptions.Lending),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Lending),
              ),
              const Divider(),
              FilterLabelChip(
                label: 'Events',
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Event),
                isIncluded: () => controller
                    .isFilterChipAsMainCategoryIncluded(CategoryOptions.Event),
                onTap: () => controller.selectFilterChip(CategoryOptions.Event),
              ),
            ],
          ),
        ),
      ),
      FilterTitle(label: 'Sotieren nach'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<FeedController>(
          builder: (c) => Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              FilterLabelChip(
                label: 'Datum',
                isSelected: () => controller
                    .isPostFilterSortBySelected(PostFilterSortBy.date),
                onTap: () =>
                    controller.selectPostFilterSortBy(PostFilterSortBy.date),
              ),
              FilterLabelChip(
                label: 'Likes',
                isSelected: () => controller
                    .isPostFilterSortBySelected(PostFilterSortBy.likes),
                onTap: () =>
                    controller.selectPostFilterSortBy(PostFilterSortBy.likes),
              ),
            ],
          ),
        ),
      ),
      FilterTitle(label: 'Reihenfolge'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<FeedController>(
          builder: (c) => Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              FilterLabelChip(
                label: 'Neueste',
                isSelected: controller.isDescending,
                onTap: controller.swapOrder,
              ),
              FilterLabelChip(
                label: 'Älteste',
                isSelected: controller.isAscending,
                onTap: controller.swapOrder,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: LocooTextButton(
          label: 'Anwenden',
          onPressed: () =>
              {controller.takeOverExtendedPostFilter(), Get.back()},
          icon: FlutterRemix.check_line,
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ]);
  }
}
