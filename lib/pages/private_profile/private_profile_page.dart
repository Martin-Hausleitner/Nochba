import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/private_profile/views/own_posts_view.dart';

import 'package:locoo/models/user.dart' as models;

import 'package:locoo/models/auth_access.dart';
import 'package:locoo/shared/ui/cards/action_card.dart';
import 'package:locoo/shared/ui/cards/action_card_title.dart';

import '../../models/data_access.dart';
import 'private_profile_controller.dart';
import 'views/edit_profile_view.dart';
import 'views/saved_posts_view.dart';
import 'views/settings_view.dart';
import 'widgets/logout_settings_cart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:locoo/models/user.dart' as models;

class PrivateProfilePage extends GetView<PrivateProfileController> {
  @override
  Widget build(BuildContext context) {
    final dataAccess = Get.find<DataAccess>();
    final authAccess = Get.find<AuthAccess>();
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
                  Padding(
                    padding: //left right 15
                        const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      //align start
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder<models.User?>(
                          future: dataAccess
                              .getUser(FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return Center(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(data.imageUrl),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${data.firstName} ${data.lastName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
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
                                      onTap: () =>
                                          Get.snackbar('title', 'message'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Fail'),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
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
                        ActionCardTitle(
                          title: 'Nachbarschaft',
                        ),
                        ActionCard(
                          title: 'Veranstaltungen',
                          icon: Icon(FlutterRemix.calendar_event_line),
                          onTap: () {
                            Get.snackbar("Pressed", "Pressed");
                          },
                        ),
                        ActionCardTitle(
                          title: 'Einstellungen',
                        ),
                        ActionCard(
                          title: 'Profil Bearbeiten',
                          icon: Icon(FlutterRemix.user_line),
                          onTap: () {
                            //get open settingfs page
                            Get.to(
                                // EditProfileView(),
                                EditProfileView());
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
                            //Get.snackbar("Pressed", "Pressed");
                            authAccess.signOut();
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
          ],
        ),
      ),
    );
  }
}








