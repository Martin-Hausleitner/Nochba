// ignore_for_file: deprecated_member_use

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/shared/round_icon_button.dart';
import 'package:locoo/shared/user_info.dart';

import '../../shared/profile_content.dart';
import '../../views/settings/settings_page.dart';
import '../feed/post/category_badge.dart';
import 'private_profile_controller.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
// import post.dart
import '../../pages/feed/post/post.dart';

class PrivateProfilePage extends GetView<PrivateProfileController> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // A ScrollView that creates custom scroll effects using slivers.
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navTitleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              // color: Theme.of(context).colorScheme.onPrimary,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            // navLargeTitleTextStyle: GoogleFonts.inter(
            //   fontSize: 30,
            //   fontWeight: FontWeight.w800,
            //   letterSpacing: -0.5,
            //   color: Theme.of(context).colorScheme.onSecondaryContainer,
            //   // color: Colors.black,
            // ),
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
            CupertinoSliverNavigationBar(
              // padding: EdgeInsetsDirectional.only(
              //   start: 7,
              //   end: 23,
              // ),

              // leading: Icon(CupertinoIcons.person_2),
              // This title is visible in both collapsed and expanded states.
              // When the "middle" parameter is omitted, the widget provided
              // in the "largeTitle" parameter is used instead in the collapsed state.
              largeTitle: Text(
                'Dein Profil  ',
              ),

              // trailing: IconButton(
              //   alignment: Alignment.topRight,
              //   icon: Icon(
              //     FlutterRemix.menu_line,
              //     size: 24,
              //     color: Theme.of(context).colorScheme.onSecondaryContainer,
              //   ),
              //   onPressed: () {
              //     Get.to(SettingsPage());
              //   },
              // ),

              //transform a contian -16 x

              trailing: Container(
                  transform: Matrix4.translationValues(14, 0, 0),
                  child: IconButton(
                    // alignment: Alignment.topRight,
                    icon: Icon(
                      FlutterRemix.menu_line,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed: () {
                      Get.to(SettingsPage());
                    },
                  )),

              // trailing: CupertinoButton(
              //   padding: EdgeInsets.zero,
              //   child: Icon(
              //     FlutterRemix.menu_line,
              //     size: 24,
              //     color: Theme.of(context).colorScheme.onSecondaryContainer,
              //   ),
              //   onPressed: () {
              //     Get.to(SettingsPage());
              //   },
              // ),

              // trailing: Icon(
              //   FlutterRemix.pencil_line,
              //   size: 24,
              //   color: Theme.of(context).colorScheme.onSecondaryContainer,
              // ),
              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // This widget fills the remaining space in the viewport.
            // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
            SliverFillRemaining(
              child: PrivateProfileContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivateProfileContent extends StatelessWidget {
  const PrivateProfileContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ProfileContent(),
        // add TabBarView with with info and post
      ],
    );
  }
}
