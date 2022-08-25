// ignore_for_file: deprecated_member_use

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/shared/action_card.dart';
import 'package:locoo/shared/round_icon_button.dart';
import 'package:locoo/shared/user_info.dart';

import '../../shared/profile_content.dart';
import '../feed/post/category_badge.dart';
import 'private_profile_controller.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
// import post.dart
import '../../pages/feed/post/post.dart';
import 'views/edit_profile_view.dart';
import 'views/own_posts_view.dart';
import 'views/saved_posts_view.dart';
import 'views/settings_view.dart';
import 'widgets/logout_settings_cart.dart';

class PrivateProfilePage extends GetView<PrivateProfileController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // A ScrollView that creates custom scroll effects using slivers.
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navTitleTextStyle:
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                      // fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      // letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
            navLargeTitleTextStyle:
                Theme.of(context).textTheme.headlineMedium?.copyWith(
                      // fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
          ),
          // barBackgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          barBackgroundColor: Theme.of(context).backgroundColor,
        ),
        child: CustomScrollView(
          // A list of sliver widgets.
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text(
                'Dein Profil  ',
              ),
              border: //make the border transparent
                  Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage('https://picsum.photos/250?image=9'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Max Mustermann',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    // fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () => Get.snackbar('title', 'message'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mein Öffentliches Profil',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.6),
                                    ),
                              ),

                              // SizedBox(
                              //   width: 2,
                              // ),
                              Icon(
                                FlutterRemix.arrow_right_s_line,
                                size: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.6),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ActionCard(
                    title: 'Deine Posts',
                    icon: Icon(
                      FlutterRemix.file_list_2_line,
                      // color: Colors.red,
                    ),
                    onTap: () {
                      //get open settingfs page
                      Get.to(OwnPostsView());
                    },
                  ),
                  ActionCard(
                    title: 'Deine Gespeicherten Posts',
                    icon: Icon(FlutterRemix.bookmark_line),
                    onTap: () {
                      //get open settingfs page
                      Get.to(SavedPostsView());
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      'Nachbarschaft',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ActionCard(
                    title: 'Veranstaltungen',
                    icon: Icon(FlutterRemix.calendar_event_line),
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      'Einstellungen',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ActionCard(
                    title: 'Profil Bearbeiten',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      //get open settingfs page
                      Get.to(
                        EditProfileView(),
                      );
                    },
                  ),
                  ActionCard(
                    title: 'Einstellungen',
                    icon: Icon(FlutterRemix.settings_3_line),
                    onTap: () {
                      //get open settingfs page
                      Get.to(
                        SettingsView(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LogoutSettingsCard(
                    onTap: () {
                      Get.snackbar("Pressed", "Pressed");
                    },
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class PrivateProfileContent extends StatelessWidget {
//   const PrivateProfileContent({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     //return a list with a column



    // return ListView(
    //   child: Column(
    //     //align centet
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    
    //       //Create a row with two columns
    //       Row(
    //         //align center
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           //Create a column with a container
    //           Column(
    //             //align center
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               //Create a container with a circle avatar
    //               Container(
    //                 width: 100,
    //                 height: 100,
    //                 decoration: BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   image: DecorationImage(
    //                     image: AssetImage('assets/images/profile_image.png'),
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),
    //               //Create a container with a name
    //               Container(
    //                 margin: EdgeInsets.only(top: 10),
    //                 child: Text(
    //                   'John Doe',
    //                   style: GoogleFonts.inter(
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.w600,
    //                     color: Theme.of(context).colorScheme.onSecondaryContainer,
    //                   ),
    //                 ),
    //               ),
    //               //Create a container with a description
    //               Container(
    //                 margin: EdgeInsets.only(top: 10),
    //                 child: Text(
    //                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    //                   style: GoogleFonts.inter(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w400,
    //                     color: Theme.of(context).colorScheme.onSecondaryContainer,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
              //Create a column with a container
    
          // create a stack with an CircleAvatar with a photo and in the right bottom corner a small circle with a edit icon in it
          // SizedBox(
          //   height: 40,
          // ),
          // Center(
          //   child: Stack(
          //     children: [
          //       const CircleAvatar(
          //         radius: 55,
          //         backgroundImage: NetworkImage(
          //           "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
          //         ),
          //       ),
          //       Positioned(
          //         bottom: 0,
          //         right: 0,
          //         child: CircleAvatar(
          //           radius: 16,
          //           backgroundColor: Theme.of(context).primaryColor,
          //           child: IconButton(
          //             icon: Icon(
          //               FlutterRemix.pencil_line,
          //               color: Colors.white,
          //               size: 17,
          //             ),
          //             // onpress open snack bar
          //             onPressed: () {
          //               Get.snackbar(
          //                 "Edift",
          //                 "Edit your profile",
          //               );
          //             },
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
    
          // // show a name
          // Padding(
          //   padding: EdgeInsets.only(top: 20),
          //   child: Text(
          //     "Maxs Mustermdann",
          //     style: Theme.of(context).textTheme.titleMedium,
          //   ),
          // ),
          // //
          // SizedBox(
          //   height: 20,
          // ),
    
          // // add a tabbarview
          // ProfileContent(),
          // add TabBarView with with info and post
//         ],
//       ),
//     );
//   }
// }
