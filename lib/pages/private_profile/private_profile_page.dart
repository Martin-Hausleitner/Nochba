// ignore_for_file: deprecated_member_use

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/shared/round_icon_button.dart';

import '../../views/settings/settings_page.dart';
import '../feed/post/category_badge.dart';
import 'private_profile_controller.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
// import post.dart
import '../../pages/feed/post/post.dart';

class PrivateProfilePage extends GetView<PrivateProfileController> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // return Scaffold(
    //   body: Container(
    //     child: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Obx(() => Text("Counter ${controller.counter.value}")),
    //           ElevatedButton(
    //             child: const Text("Increase"),
    //             onPressed: () => controller.increaseCounter(),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         pinned: true,
    //         // leading: IconButton(
    //         //   icon: Icon(Icons.arrow_back_ios_sharp),
    //         //   onPressed: () {},
    //         // ),
    //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //         actions: const [
    //           Icon(
    //             FlutterRemix.settings_2_line,
    //             color: Colors.black87,
    //           ),
    //         ],
    //         shadowColor: Colors.transparent,

    //         /// The part you use this package
    //         flexibleSpace: CustomizableSpaceBar(
    //           builder: (context, scrollingRate) {
    //             return Padding(
    //               // padding: EdgeInsets.only(
    //               //     bottom: 13, left: 12 + 40 * scrollingRate),
    //               padding: EdgeInsets.only(
    //                   bottom: 13, left: 12),
    //               child: Align(
    //                 alignment: Alignment.bottomLeft,
    //                 child: Row(
    //                   children: [
    //                     Text(
    //                       "Dein Profil",
    //                       style: TextStyle(
    //                           fontSize: 42 - 18 * scrollingRate,
    //                           fontWeight: FontWeight.bold),
    //                     ),

    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),

    //         /// End of the part
    //         expandedHeight: 150,
    //       ),
    //       SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //           (context, index) {
    //             return ListTile(
    //               title: Text("LIST ITEM"),
    //             );
    //           },
    //         ),
    //       )
    //     ],
    //   ),
    // );
    // return Scaffold( with a colum and a row with headline5 text and a settings icon
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dein Profil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FlutterRemix.settings_3_line,
              color: Colors.black,
            ),
            //onPress open SettingsPage
            onPressed: () {
              Get.to(SettingsPage(),
                  transition: Transition.rightToLeftWithFade);
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.navigate_next),
          //   tooltip: 'Go to the next page',
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute<void>(
          //       builder: (BuildContext context) {
          //         return Scaffold(
          //           appBar: AppBar(
          //             title: const Text('Next page'),
          //           ),
          //           body: const Center(
          //             child: Text(
          //               'This is the next page',
          //               style: TextStyle(fontSize: 24),
          //             ),
          //           ),
          //         );
          //       },
          //     ));
          //   },
          // ),
        ],
      ),
      body: Column(
        //align centet
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // create a stack with an CircleAvatar with a photo and in the right bottom corner a small circle with a edit icon in it
          SizedBox(
            height: 40,
          ),
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: Icon(
                        FlutterRemix.pencil_line,
                        color: Colors.white,
                        size: 17,
                      ),
                      // onpress open snack bar
                      onPressed: () {
                        Get.snackbar(
                          "Edift",
                          "Edit your profile",
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // show a name
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Maxs Mustermdann",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          //
          SizedBox(
            height: 20,
          ),

          // add a tabbarview
          Expanded(
            // width: width,
            // height: height,
            child: ContainedTabBarView(
              tabs: [
                Text('Info', style: TextStyle(fontSize: 20)),
                Text('Posts', style: TextStyle(fontSize: 20)),
              ],
              tabBarProperties: TabBarProperties(
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 4.0,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey[400],
              ),
              views: [
                Container(color: Colors.red.shade100),
                // create a container with a list of post.dart
                Container(
                  color: Color.fromARGB(146, 238, 238, 238),
                  child: ListView(children: [
                    SizedBox(height: 6),
                    Post(
                      postTitle: 'Post ddddddddddddTitle',
                      postImage: 'https://i.pravatar.cc/303',
                      postCategory: Category.mitteilung,
                      postAuthorName: 'John Doe',
                      postPublishDate: '2',
                      postDistance: '1',
                      postDescription: 'Post Dddddescrisssption',
                    ),
                    SizedBox(height: 3),
                    Post(
                      postTitle: 'Post Title',
                      postImage: 'https://i.pravatar.cc/303',
                      postAuthorName: 'John Doe',
                      postPublishDate: '2',
                      postDistance: '1',
                      postDescription:
                          'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
                    ),
                    SizedBox(height: 3),
                    Post(
                      postTitle:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      postImage: 'https://i.pravatar.cc/303',
                      postAuthorName: 'John Doe',
                      postPublishDate: '2',
                      postCategory: Category.warnung,
                      postDistance: '1',
                      postDescription:
                          'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
                    ),
                  ]),
                ),
              ],
              onChange: (index) => print(index),
            ),
          ),
          // add TabBarView with with info and post
        ],
      ),
    );
  }
}

class SampleWidget extends StatelessWidget {
  const SampleWidget({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
      child: Text(label),
    );
  }
}
