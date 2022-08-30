import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/pages/private_profile/views/own_posts_view.dart';
import 'package:locoo/shared/action_card.dart';

import 'package:locoo/models/user.dart' as models;

import 'package:locoo/models/auth_access.dart';
import 'package:locoo/shared/action_card_title.dart';
import 'package:locoo/shared/action_text_card.dart';
import 'package:locoo/shared/app_bar_big_view.dart';
import 'package:locoo/shared/locoo_text_field.dart';
import 'package:locoo/shared/round_icon_button.dart';
import 'package:locoo/shared/user_info.dart';

import '../../models/data_access.dart';
import 'private_profile_controller.dart';
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

class EditProfileView extends StatelessWidget {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(title: 'Profil Bearbeiten', children: [
      // SizedBox(
      //   height: 30,
      // ),
      EditAvatar(),
      SizedBox(
        height: 30,
      ),
      ActionCardTitle(title: 'Persönliche Daten'),
      ActionTextCard(
        title: 'Name',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheet(
                children: [
                  LocooTextField(
                    label: 'Vorname',
                  ),
                  SizedBox(height: 10),
                  LocooTextField(
                    label: 'Nachname',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: // right left 5
                        EdgeInsets.only(
                      left: 7,
                      right: 7,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Zeiger nur den ersten Buchstaben deines Nachnahmen an',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.6)),
                          ),
                        ),
                        //tranform  scale 0.8 cupertuon swtich
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: Theme.of(context).primaryColor,
                            value: true,
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        text: 'Martin Hausleitner',
      ),
      ActionTextCard(
        title: 'Geburtstag',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheet(
                children: [
                  Column(
                    children: [
                      SfDateRangePicker(
                        view: DateRangePickerView.decade,
                        // monthViewSettings:
                        //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                        showNavigationArrow: true,
                        // showActionButtons: true,
                        maxDate: DateTime.now(),
                        minDate: DateTime(1880),
                        //set initial year to 1999
                        // enableMultiView: true,
                        initialDisplayDate: DateTime(2000),
                        // when onSubmit () => Navigator.pop(context),
                        // onSubmit: (value) {
                        //   Navigator.pop(context);
                        // },

                        yearCellStyle: DateRangePickerYearCellStyle(
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.7),
                                  ),
                          leadingDatesTextStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.7),
                                  ),
                        ),
                      ),
                      Padding(
                        padding: // right left 5
                            EdgeInsets.only(
                          left: 7,
                          right: 7,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Zeiger deinen Geburtstag an in deinen Öffentlichen Profil an',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.6)),
                              ),
                            ),
                            //tranform  scale 0.8 cupertuon swtich
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                activeColor: Theme.of(context).primaryColor,
                                value: true,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        text: '01.01.2022',
      ),
      ActionTextCard(
        title: 'In der Nachbarschaft seit',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheet(
                children: [
                  SfDateRangePicker(
                    view: DateRangePickerView.decade,
                    // monthViewSettings:
                    //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    showNavigationArrow: true,
                    // showActionButtons: true,
                    maxDate: DateTime.now(),
                    minDate: DateTime(1880),
                    //set initial year to 1999
                    // enableMultiView: true,
                    initialDisplayDate: DateTime(2000),
                    // when onSubmit () => Navigator.pop(context),
                    // onSubmit: (value) {
                    //   Navigator.pop(context);
                    // },

                    yearCellStyle: DateRangePickerYearCellStyle(
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                      leadingDatesTextStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        text: '01.01.2022',
      ),
      ActionTextCard(
        title: 'Beruf',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheet(
                children: [
                  LocooTextField(
                    label: 'Beruf',
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          );
        },
        text: 'Legobaumeister',
      ),

      ActionTextCard(
        title: 'Mehr über dich',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheet(
                children: [
                  LocooTextField(
                    label: 'Mehr über dich',
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          );
        },
        text: 'Hallo, mein name ist martin und ich bin ein legobaumeister',
      ),
      ActionCardTitle(title: 'Mehr'),
      ActionTextCard(
        title: 'Interessen',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Freunde, Familie, Legobaumeister',
      ),
      ActionTextCard(
        title: 'Bietet',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Babysitten, Nachb',
      ),
      ActionCardTitle(title: 'Familie'),
      ActionTextCard(
        title: 'Familien Status',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Verheiratet',
      ),
      ActionTextCard(
        title: 'Kinder',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheet(
                children: [
                  // ad a counter with + an- buttons
                  Row(
                    children: [
                      Text('0'),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(FlutterRemix.add_line),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(FlutterRemix.subtract_line),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        text: '3',
      ),
      ActionTextCard(
        title: 'Tiere',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Hund, Katze',
      ),

      // Padding(
      //   padding:
      //       //left 18
      //       EdgeInsets.only(left: 15, top: 20),
      //   child: ActionCardTitle(title: 'Sicherheit'),
      // ),
      //create a input field which check if the input is the same as a string and if it is the same it will run a function

      SizedBox(
        height: 40,
      ),
    ]);
  }
}

class BottomSheet extends StatelessWidget {
  //children
  final List<Widget> children;

  const BottomSheet({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: //top 10
                  EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
              ),
              child: Row(
                children: [
                  //iconButton black x -> close sheet
                  SimpleCircularIconButton(
                    iconData: FlutterRemix.close_line,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.05),
                    iconColor: Colors.black,
                    radius: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),

                  SimpleCircularIconButton(
                    iconData: FlutterRemix.check_line,
                    fillColor: Theme.of(context).primaryColor,
                    iconColor: Colors.white,
                    radius: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditAvatar extends StatelessWidget {
  const EditAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                splashRadius: 16,
                splashColor: Theme.of(context).primaryColor.withOpacity(.4),
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
    );
  }
}

class SimpleCircularIconButton extends StatelessWidget {
  const SimpleCircularIconButton(
      {this.fillColor = Colors.transparent,
      required this.iconData,
      this.iconColor = Colors.blue,
      this.outlineColor = Colors.transparent,
      this.notificationFillColor = Colors.red,
      this.notificationCount,
      this.onPressed,
      this.radius = 48.0,
      Key? key})
      : super(key: key);

  final IconData iconData;
  final Color fillColor;
  final Color outlineColor;
  final Color iconColor;
  final Color notificationFillColor;
  final int? notificationCount;
  final Function? onPressed;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Ink(
          width: radius,
          height: radius,
          decoration: ShapeDecoration(
            color: fillColor,
            shape: CircleBorder(side: BorderSide(color: outlineColor)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: radius / 2,
            iconSize: radius / 2,
            icon: Icon(iconData, color: iconColor),
            splashColor: iconColor.withOpacity(.4),
            onPressed: onPressed as void Function()?,
          ),
        ),
        if (notificationCount != null) ...[
          Positioned(
            top: radius / -14,
            right: radius / -14,
            child: Container(
              width: radius / 2.2,
              height: radius / 2.2,
              decoration: ShapeDecoration(
                color: notificationFillColor,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: Text(
                  notificationCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: radius / 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// class OwnPostsView extends StatelessWidget {
//   const OwnPostsView({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final dataAccess = Get.find<DataAccess>();

//     return AppBarView(
//       title: 'title',
//       children: [
//         Expanded(
//           child: StreamBuilder<List<models.Post>>(
//             stream: dataAccess
//                 .getPostsOfUser(FirebaseAuth.instance.currentUser!.uid),
//             builder: ((context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text(
//                     'Something went wrong: ${snapshot.error.toString()}',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         fontSize: 32, fontWeight: FontWeight.w300));
//               } else if (snapshot.hasData) {
//                 final posts = snapshot.data!;

//                 return ListView.separated(
//                   shrinkWrap: true,
//                   itemCount: posts.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final post = posts.elementAt(index);

//                     return FutureBuilder<models.User?>(
//                       future: dataAccess.getUser(post.user),
//                       builder: ((context, snapshot) {
//                         if (snapshot.hasData) {
//                           final user = snapshot.data!;
//                           return widget.Post(
//                             post: post,
//                             postAuthorName:
//                                 '${user.firstName} ${user.lastName}',
//                             postAuthorImage: user.imageUrl,
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) =>
//                       const SizedBox(height: 3),
//                 );
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//                 // return const Text('There are no posts in the moment',
//                 //   textAlign: TextAlign.center,
//                 //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300));
//               }
//             }),
//           ),
//         ),
//       ].toList(),
//     );
//   }
// }

class SavedPostsView extends StatelessWidget {
  const SavedPostsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(title: 'Gespeicherten Posts', children: [
      Text('lol'),
    ]);
  }
}
