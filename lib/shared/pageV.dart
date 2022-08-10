// import 'package:expandable_page_view/expandable_page_view.dart';
// import 'package:flutter/material.dart';

// import '../pages/feed/post/category_badge.dart';
// import '../pages/feed/post/post.dart';

// import 'package:flutter/widgets.dart';
// import 'package:collection/collection.dart';

// class ExpandablePageView extends StatefulWidget {
//   final int itemCount;
//   final Widget Function(BuildContext, int) itemBuilder;
//   final PageController controller;
//   final ValueChanged<int> onPageChanged;
//   final bool reverse;

//   const ExpandablePageView({
//     required this.itemCount,
//     required this.itemBuilder,
//     this.controller,
//     this.onPageChanged,
//     this.reverse = false,
//     Key key,
//   })  : assert(itemCount != null),
//         assert(itemBuilder != null),
//         super(key: key);

//   @override
//   _ExpandablePageViewState createState() => _ExpandablePageViewState();
// }

// class _ExpandablePageViewState extends State<ExpandablePageView> {
//   PageController _pageController;
//   List<double> _heights;
//   int _currentPage = 0;

//   double get _currentHeight => _heights[_currentPage];

//   @override
//   void initState() {
//     super.initState();
//     _heights = List.filled(widget.itemCount, 0, growable: true);
//     _pageController = widget.controller ?? PageController();
//     _pageController.addListener(_updatePage);
//   }

//   @override
//   void dispose() {
//     _pageController?.removeListener(_updatePage);
//     _pageController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       curve: Curves.easeInOutCubic,
//       tween: Tween<double>(begin: _heights.first, end: _currentHeight),
//       duration: const Duration(milliseconds: 100),
//       builder: (context, value, child) => SizedBox(height: value, child: child),
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: widget.itemCount,
//         itemBuilder: _itemBuilder,
//         onPageChanged: widget.onPageChanged,
//         reverse: widget.reverse,
//       ),
//     );
//   }

//   Widget _itemBuilder(BuildContext context, int index) {
//     final item = widget.itemBuilder(context, index);
//     return OverflowBox(
//       minHeight: 0,
//       maxHeight: double.infinity,
//       alignment: Alignment.topCenter,
//       child: SizeReportingWidget(
//         onSizeChange: (size) => setState(() => _heights[index] = size?.height ?? 0),
//         child: item,
//       ),
//     );
//   }
//   void _updatePage() {
//     final newPage = _pageController.page.round();
//     if (_currentPage != newPage) {
//       setState(() {
//         _currentPage = newPage;
//       });
//     }
//   }
// }

// class SizeReportingWidget extends StatefulWidget {
//   final Widget child;
//   final ValueChanged<Size> onSizeChange;

//   const SizeReportingWidget({
//     @required this.child,
//     @required this.onSizeChange,
//     Key key,
//   })  : assert(child != null),
//         assert(onSizeChange != null),
//         super(key: key);

//   @override
//   _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
// }

// class _SizeReportingWidgetState extends State<SizeReportingWidget> {
//   Size _oldSize;

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
//     return widget.child;
//   }

//   void _notifySize() {
//     final size = context?.size;
//     if (_oldSize != size) {
//       _oldSize = size;
//       widget.onSizeChange(size);
//     }
//   }
// }

// // class PageV extends StatelessWidget {
// //   const PageV({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return ExpandablePageView(
// //       scrollDirection: Axis.vertical,
// //       children: [
// //         // Post(
// //         //   postTitle: 'Post ddddddddddddTitle',
// //         //   postImage: 'https://i.pravatar.cc/303',
// //         //   postCategory: Category.mitteilung,
// //         //   postAuthorName: 'John Doe',
// //         //   postPublishDate: '2',
// //         //   postDistance: '1',
// //         //   postDescription: 'Post Dddddescrisssption',
// //         // ),
// //         // Post(
// //         //   postTitle: 'Post Title',
// //         //   postImage: 'https://i.pravatar.cc/303',
// //         //   postAuthorName: 'John Doe',
// //         //   postPublishDate: '2',
// //         //   postDistance: '1',
// //         //   postDescription:
// //         //       'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
// //         // ),
// //         // Post(
// //         //   postTitle:
// //         //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
// //         //   postImage: 'https://i.pravatar.cc/303',
// //         //   postAuthorName: 'John Doe',
// //         //   postPublishDate: '2',
// //         //   postCategory: Category.warnung,
// //         //   postDistance: '1',
// //         //   postDescription:
// //         //       'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
// //         // ),

// //         //create a red box with hight 100
// //         Container(
// //           color: Colors.red,
// //           height: 100,
// //         ),
// //         //create a green box with hight 100
// //         Container(
// //           color: Colors.green,
// //           height: 100,
// //         ),
// //         //create a blue box with hight 100
// //         Container(
// //           color: Colors.blue,
// //           height: 100,
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class StackTest extends StatefulWidget {
// //   const StackTest({Key? key}) : super(key: key);

// //   @override
// //   State<StackTest> createState() => _StackTestState();
// // }

// // class _StackTestState extends State<StackTest> {
// //   final List<Widget> images = [
// //     Post(
// //       postTitle:
// //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
// //       postImage: 'https://i.pravatar.cc/303',
// //       postAuthorName: 'John Doe',
// //       postPublishDate: '2',
// //       postCategory: Category.warnung,
// //       postDistance: '1',
// //       postDescription:
// //           'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
// //     ),
// //     Container(
// //       decoration: BoxDecoration(
// //         color: Colors.green,
// //         borderRadius: BorderRadius.all(Radius.circular(10)),
// //       ),
// //     ),
// //     Container(
// //       decoration: BoxDecoration(
// //         color: Colors.cyan,
// //         borderRadius: BorderRadius.all(Radius.circular(10)),
// //       ),
// //     ),
// //     Container(
// //       decoration: BoxDecoration(
// //         color: Colors.grey,
// //         borderRadius: BorderRadius.all(Radius.circular(10)),
// //       ),
// //     ),
// //   ];
// //   List<double> testHeight = [100, 300, 500];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Dynamic Height PageView',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
// //         child: Container(
// //           child: DynamicHeightPageView(
// //             heightList: testHeight,
// //             children: images,
// //             onSelectedItem: (index) {
// //               print("index: $index");
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // typedef PageChangedCallback = void Function(double? page);
// // typedef PageSelectedCallback = void Function(int index);

// // class DynamicHeightPageView extends StatefulWidget {
// //   final List<double> heightList;
// //   final List<Widget> children;
// //   final double cardWidth;
// //   final ScrollPhysics? physics;
// //   final PageChangedCallback? onPageChanged;
// //   final PageSelectedCallback? onSelectedItem;
// //   final int initialPage;

// //   DynamicHeightPageView({
// //     required this.heightList,
// //     required this.children,
// //     this.physics,
// //     this.cardWidth = 300,
// //     this.onPageChanged,
// //     this.initialPage = 0,
// //     this.onSelectedItem,
// //   }) : assert(heightList.length == children.length);

// //   @override
// //   _DynamicHeightPageViewState createState() => _DynamicHeightPageViewState();
// // }

// // class _DynamicHeightPageViewState extends State<DynamicHeightPageView> {
// //   double? currentPosition;
// //   PageController? controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     currentPosition = widget.initialPage.toDouble();
// //     controller = PageController(initialPage: widget.initialPage);

// //     controller!.addListener(() {
// //       setState(() {
// //         currentPosition = controller!.page;

// //         if (widget.onPageChanged != null) {
// //           Future(() => widget.onPageChanged!(currentPosition));
// //         }

// //         if (widget.onSelectedItem != null && (currentPosition! % 1) == 0) {
// //           Future(() => widget.onSelectedItem!(currentPosition!.toInt()));
// //         }
// //       });
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return LayoutBuilder(builder: (context, constraints) {
// //       return GestureDetector(
// //         onTap: () {
// //           print("Current Element index tab: ${currentPosition!.round()}");
// //         },
// //         child: Stack(
// //           children: [
// //             CardController(
// //               cardWidth: widget.cardWidth,
// //               heightList: widget.heightList,
// //               children: widget.children,
// //               currentPosition: currentPosition,
// //               cardViewPagerHeight: constraints.maxHeight,
// //               cardViewPagerWidth: constraints.maxWidth,
// //             ),
// //             Positioned.fill(
// //               child: PageView.builder(
// //                 physics: widget.physics,
// //                 scrollDirection: Axis.vertical,
// //                 itemCount: widget.children.length,
// //                 controller: controller,
// //                 itemBuilder: (context, index) {
// //                   return Container();
// //                 },
// //               ),
// //             )
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }

// // class CardController extends StatelessWidget {
// //   final double? currentPosition;
// //   final List<double> heightList;
// //   final double cardWidth;
// //   final double cardViewPagerHeight;
// //   final double? cardViewPagerWidth;
// //   final List<Widget>? children;

// //   CardController({
// //     this.children,
// //     this.cardViewPagerWidth,
// //     required this.cardWidth,
// //     required this.cardViewPagerHeight,
// //     required this.heightList,
// //     this.currentPosition,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     List<Widget> cardList = [];

// //     for (int i = 0; i < children!.length; i++) {
// //       var cardHeight = heightList[i];

// //       var cardTop = getTop(cardHeight, cardViewPagerHeight, i, heightList);
// //       var cardLeft = (cardViewPagerWidth! / 2) - (cardWidth / 2);

// //       Widget card = Positioned(
// //         top: cardTop,
// //         left: cardLeft,
// //         child: Container(
// //           width: cardWidth,
// //           height: cardHeight,
// //           child: children![i],
// //         ),
// //       );

// //       cardList.add(card);
// //     }

// //     return Stack(
// //       children: cardList,
// //     );
// //   }

// //   double getTop(
// //       double cardHeight, double viewHeight, int i, List<double> heightList) {
// //     double diff = (currentPosition! - i);
// //     double diffAbs = diff.abs();

// //     double basePosition = (viewHeight / 2) - (cardHeight / 2);

// //     if (diffAbs == 0) {
// //       //element in focus
// //       return basePosition;
// //     }

// //     int intCurrentPosition = currentPosition!.toInt();
// //     double doubleCurrentPosition = currentPosition! - intCurrentPosition;

// //     //calculate distance between to-pull elements
// //     late double pullHeight;
// //     if (heightList.length > intCurrentPosition + 1) {
// //       //check for end of list
// //       pullHeight = heightList[intCurrentPosition] / 2 +
// //           heightList[intCurrentPosition + 1] / 2;
// //     } else {
// //       pullHeight = heightList[intCurrentPosition] / 2;
// //     }

// //     if (diff >= 0) {
// //       //before focus element
// //       double afterListSum = heightList.getRange(i, intCurrentPosition + 1).sum;

// //       return (viewHeight / 2) -
// //           afterListSum +
// //           heightList[intCurrentPosition] / 2 -
// //           pullHeight * doubleCurrentPosition;
// //     } else {
// //       //after focus element
// //       var beforeListSum = heightList.getRange(intCurrentPosition, i).sum;
// //       return (viewHeight / 2) +
// //           beforeListSum -
// //           heightList[intCurrentPosition] / 2 -
// //           pullHeight * doubleCurrentPosition;
// //     }
// //   }
// // }
