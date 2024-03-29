import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/category.dart';

import 'package:nochba/logic/models/post.dart' as models;
import 'package:nochba/pages/feed/views/feed_post_filter_view.dart';
import 'package:nochba/pages/feed/widgets/post/loading_post.dart';
import 'package:nochba/pages/feed/widgets/post_card.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
            Container(
              // height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                // color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: // top left right 14
                        const EdgeInsets.only(top: 14, left: 14, right: 14),
                    child: Column(
                      //align start
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // const SizedBox(height: 10),
                        // const Text(
                        //   'Neues in deiner',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     letterSpacing: -0.5,
                        //     fontWeight: FontWeight.w800,
                        //   ),
                        // ),
                        // // larger text in primery Nachbarschaft
                        // Text(
                        //   'Nachbarschaft',
                        //   style: TextStyle(
                        //     fontSize: 25,
                        //     fontWeight: FontWeight.w800,
                        //     letterSpacing: -0.5,
                        //     color: Theme.of(context).primaryColor,
                        //   ),
                        // ),
                        // const SizedBox(height: 30),
                        FilterButton(controller: controller),
                        const SizedBox(height: 10),

                        //Create a SingleChildScrollView with a row  of chips which can be selected. when seclected the color of the chip changes to primery
                      ],
                    ),
                  ),
                  CategoryChooser(controller: controller),
                ],
              ),
            ),
            Expanded(
              // child: GetBuilder<FeedController>(
              //   builder: (c) => controller.searchInputController.text.isNotEmpty
              //       ? PostListSearch(controller: controller)
              //       : PostList(controller: controller),
              // ),
              child: GetBuilder<FeedController>(
                id: 'Feed',
                builder: (c) => PostList(controller: controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.controller,
  });

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchBar(controller: controller),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            controller.updateExtendedPostFilter();
            await showModalBottomSheet<void>(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return FeedPostFilterView(
                  controller: controller,
                );
              },
            );
          },
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              FlutterRemix.filter_3_line,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.controller,
  });

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //color Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      // round corners
      // height: 30,
      // child: Container(),
      //create a textfield with a gray background and a search icon on the left with field of height 38
      child: SizedBox(
        height: 38,
        child: TextField(
          onChanged: controller.onSearchInputChanged,
          controller: controller.searchInputController,
          decoration: InputDecoration(
            //set padding 0
            contentPadding: const EdgeInsets.all(0),
            filled: true,
            // fillColor: Theme.of(context)
            //     .colorScheme
            //     .onSurface
            //     .withOpacity(0.04),
            fillColor: Theme.of(context).colorScheme.onPrimary,
            hintText: AppLocalizations.of(context)!.searchPosts,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              FlutterRemix.search_2_line,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class PostListSearch extends StatelessWidget {
  const PostListSearch({
    super.key,
    required this.controller,
  });

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<models.Post>>(
      future: controller.searchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return //list of 2 LoadingPost
              ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return const LoadingPost();
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 3),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              //center
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // add a forum icon

                Icon(
                  // errpr info icon

                  Icons.error_outline_outlined,

                  size: 100,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
                Text(
                  'Es konnten keine Posts geladen werden',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.15),
                      ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return Center(
              child: Column(
                //center
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // add a forum icon
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),

                  Icon(
                    Icons.article_outlined,
                    size: 100,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                  ),
                  Text(
                    'Es wurde nichts in der Suche gefunden',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.15),
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts.elementAt(index);

              return Padding(
                padding: // top 3
                    const EdgeInsets.only(top: 3),
                child: Post(post: post),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 0),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.controller,
  });

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<models.Post>>(
      future: controller.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return //list of 2 LoadingPost
              ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return const LoadingPost();
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 3),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              //center
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // add a forum icon

                Icon(
                  // errpr info icon

                  Icons.error_outline_outlined,

                  size: 100,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
                Text(
                  'Es konnten keine Posts geladen werden',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.15),
                      ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return Center(
              child: Column(
                //center
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // add a forum icon

                  Icon(
                    Icons.article_outlined,
                    size: 100,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                  ),
                  Text(
                    'Es sind noch keine posts vorhanden',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.15),
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts.elementAt(index);

              return Padding(
                padding: // top 3
                    const EdgeInsets.only(top: 3),
                child: Post(
                  post: post,
                  afterAction: controller.updateFeed,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 0),
          );
        } else {
          return Container();
          // return const Text('There are no posts in the moment',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
        }
      },
    );
  }
}

class CategoryChooser extends StatelessWidget {
  const CategoryChooser({
    super.key,
    required this.controller,
  });

  final FeedController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: //left 14
          const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: GetBuilder<FeedController>(
          id: 'FeedFilter',
          builder: (c) => Row(
            children: [
              const SizedBox(width: 14),
              CategorieChip(
                label: AppLocalizations.of(context)!.all,
                category: CategoryOptions.None,
                isSelected: controller.isCategoryChipSelected,
                onTap: controller.selectCategoryChip,
              ),
              const SizedBox(width: 06),
              CategorieChip(
                label: AppLocalizations.of(context)!.messageKategory,
                category: CategoryOptions.Message,
                isSelected: controller.isCategoryChipSelected,
                isIncluded: controller.isCategoryChipAsMainCategoryIncluded,
                onTap: controller.selectCategoryChip,
              ),
              const SizedBox(width: 06),
              CategorieChip(
                label: AppLocalizations.of(context)!.searchKategory,
                category: CategoryOptions.Search,
                isSelected: controller.isCategoryChipSelected,
                isIncluded: controller.isCategoryChipAsMainCategoryIncluded,
                onTap: controller.selectCategoryChip,
              ),
              const SizedBox(width: 06),
              CategorieChip(
                label: AppLocalizations.of(context)!.lendingKategory,
                category: CategoryOptions.Lending,
                isSelected: controller.isCategoryChipSelected,
                isIncluded: controller.isCategoryChipAsMainCategoryIncluded,
                onTap: controller.selectCategoryChip,
              ),
              const SizedBox(width: 06),
              CategorieChip(
                label: AppLocalizations.of(context)!.eventKategory,
                category: CategoryOptions.Event,
                isSelected: controller.isCategoryChipSelected,
                isIncluded: controller.isCategoryChipAsMainCategoryIncluded,
                onTap: controller.selectCategoryChip,
              ),
              const SizedBox(width: 06),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorieChip extends StatelessWidget {
  const CategorieChip(
      {Key? key,
      required this.label,
      required this.category,
      required this.isSelected,
      this.isIncluded = emptyFunction,
      required this.onTap})
      : super(key: key);

  final String label;
  final CategoryOptions category;
  final bool Function(CategoryOptions) isSelected;
  final bool Function(CategoryOptions) isIncluded;
  final Function(CategoryOptions) onTap;

  static bool emptyFunction(CategoryOptions categoryOptions) => false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected(category)
              ? Theme.of(context).colorScheme.primary
              : isIncluded(category)
                  ? Theme.of(context).colorScheme.surface
                  : //set color as post color
                  Theme.of(context).colorScheme.onPrimary,
          //: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected(category)
                ? Theme.of(context).colorScheme.onPrimary
                : isIncluded(category)
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
