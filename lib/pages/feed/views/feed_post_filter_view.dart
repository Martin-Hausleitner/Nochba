import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/PostFilter.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/pages/feed/feed_controller.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_range_slider.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_chip.dart';
import 'package:nochba/pages/feed/widgets/filter/filter_title.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/views/bottom_sheet_title_close_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class FeedPostFilterView extends StatelessWidget {
  const FeedPostFilterView({super.key, required this.controller});

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(title: 'Filter', children: [
      GetBuilder<FeedController>(
          id: 'PostFilterRangeSlider',
          builder: (c) => FilterRangeSlider(
                sliderValue: controller.sliderValue,
                onChanged: controller.onSliderValueChanged,
              )),
      FilterTitle(label: AppLocalizations.of(context)!.filterByKategory),
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
                label: AppLocalizations.of(context)!.all,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.None),
                onTap: () => controller.selectFilterChip(CategoryOptions.None),
              ),
              // const Divider(),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.messageKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Message),
                isIncluded: () => controller.isFilterChipAsMainCategoryIncluded(
                    CategoryOptions.Message),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Message),
              ),
              const SizedBox(width: 10),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.questionKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Question),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Question),
              ),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.complaintKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Appeal),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Appeal),
              ),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.warningKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Warning),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Warning),
              ),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.recommendationKategory,
                isSelected: () => controller
                    .isFilterChipSelected(CategoryOptions.Recommendation),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Recommendation),
              ),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.foundKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Found),
                onTap: () => controller.selectFilterChip(CategoryOptions.Found),
              ),
              // Container(),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.searchKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Search),
                isIncluded: () => controller
                    .isFilterChipAsMainCategoryIncluded(CategoryOptions.Search),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Search),
              ),
              const SizedBox(width: 10),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.helpKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Help),
                onTap: () => controller.selectFilterChip(CategoryOptions.Help),
              ),

              FilterLabelChip(
                label: AppLocalizations.of(context)!.lostKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Lost),
                onTap: () => controller.selectFilterChip(CategoryOptions.Lost),
              ),
              Container(),

              FilterLabelChip(
                label: AppLocalizations.of(context)!.lendingKategory,
                isSelected: () =>
                    controller.isFilterChipSelected(CategoryOptions.Lending),
                isIncluded: () => controller.isFilterChipAsMainCategoryIncluded(
                    CategoryOptions.Lending),
                onTap: () =>
                    controller.selectFilterChip(CategoryOptions.Lending),
              ),
              // const Divider(),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.eventKategory,
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
      FilterTitle(label: AppLocalizations.of(context)!.sortBy),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<FeedController>(
          builder: (c) => Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              FilterLabelChip(
                label: AppLocalizations.of(context)!.date,
                isSelected: () => controller
                    .isPostFilterSortBySelected(PostFilterSortBy.date),
                onTap: () =>
                    controller.selectPostFilterSortBy(PostFilterSortBy.date),
              ),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.likes,
                isSelected: () => controller
                    .isPostFilterSortBySelected(PostFilterSortBy.likes),
                onTap: () =>
                    controller.selectPostFilterSortBy(PostFilterSortBy.likes),
              ),
            ],
          ),
        ),
      ),
      FilterTitle(label: AppLocalizations.of(context)!.orderBy),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder<FeedController>(
          builder: (c) => Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              FilterLabelChip(
                label: AppLocalizations.of(context)!.latest,
                isSelected: controller.isDescending,
                onTap: controller.swapOrder,
              ),
              FilterLabelChip(
                label: AppLocalizations.of(context)!.oldest,
                isSelected: controller.isAscending,
                onTap: controller.swapOrder,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: LocooTextButton(
          label: AppLocalizations.of(context)!.apply,
          onPressed: () =>
              {controller.takeOverExtendedPostFilter(), Get.back()},
          icon: FlutterRemix.check_line,
        ),
      ),
      const SizedBox(
        height: 15,
      ),
    ]);
  }
}
