import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/pages/private_profile/views/own_posts_view.dart';

import 'package:nochba/logic/models/user.dart' as models;

import 'package:nochba/logic/auth_access.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/cards/action_card_title.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';

import 'private_profile_controller.dart';
import 'views/bookmarked_posts_view.dart';
import 'views/edit_profile_view.dart';
import 'views/invite_neighbor_view.dart';
import 'views/settings_view.dart';
import 'widgets/logout_settings_cart.dart';

class PrivateProfilePage extends GetView<PrivateProfileController> {
  @override
  Widget build(BuildContext context) {
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
                          future: controller.getCurrentUser(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return Center(
                                child: Column(
                                  children: [
                                    // CircleAvatar(
                                    //   radius: 50,
                                    //   backgroundImage:
                                    //       NetworkImage(data.imageUrl),
                                    // ),
                                    LocooCircleAvatar(
                                      imageUrl: data.imageUrl,
                                      radius: 55,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FutureBuilder<UserPrivateInfoName?>(
                                        future: controller.getCurrentUserName(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                              'Der Name kann zurzeit nicht geladen werden',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    // fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: -0.3,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                  ),
                                            );
                                          } else if (snapshot.hasData) {
                                            final data2 = snapshot.data!;
                                            return Text(
                                              '${data2.firstName} ${data2.lastName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    // fontSize: 30,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: -0.3,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                  ),
                                            );
                                          }
                                          return Container();
                                        }),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      //center
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FlutterRemix.map_pin_line,
                                          size: 13,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.6),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          'Auwiesen',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withOpacity(0.5),
                                              ),
                                        ),
                                      ],
                                    ),

                                    // GestureDetector(
                                    //   onTap: () =>
                                    //       Get.snackbar('title', 'message'),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         'Mein Öffentliches Profil',
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .bodyMedium
                                    //             ?.copyWith(
                                    //               color: Theme.of(context)
                                    //                   .textTheme
                                    //                   .bodyMedium
                                    //                   ?.color
                                    //                   ?.withOpacity(0.6),
                                    //             ),
                                    //       ),

                                    //       // SizedBox(
                                    //       //   width: 2,
                                    //       // ),
                                    //       Icon(
                                    //         FlutterRemix.arrow_right_s_line,
                                    //         size: 15,
                                    //         color: Theme.of(context)
                                    //             .textTheme
                                    //             .bodyMedium
                                    //             ?.color
                                    //             ?.withOpacity(0.6),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    'Das Profil ist momentan nicht verfügbar'),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // ActionCardTitle(
                        //   title: 'Dein Profil',
                        // ),
                        InviteNeighborCard(),
                        // TextButton(
                        //   onPressed: () => throw Exception(),
                        //   child: const Text("Throw Test Exception"),
                        // ),
                        GenerateVerificationCode(),
                        GetDistanceFromLatLonInMeters(),
                        VerifyButton(),
                        CheckAddressWithDeviceLocation(),
                        ActionCard(
                          title: 'Dein Öffentliches Profil',
                          icon: FlutterRemix.user_line,
                          onTap: () => controller.pushPublicProfileView(),
                        ),
                        ActionCard(
                          title: 'Deine Posts',
                          icon: FlutterRemix.file_list_2_line,
                          // color: Colors.red,

                          onTap: () {
                            //get open settingfs page

                            Get.to(
                              fullscreenDialog: true,
                              transition: Transition.cupertino,
                              OwnPostsView(
                                controller: controller,
                              ),
                            );
                          },
                        ),
                        ActionCard(
                          title: 'Deine Gespeicherten Posts',
                          icon: FlutterRemix.bookmark_line,
                          onTap: () {
                            //get open settingfs page
                            Get.to(
                              fullscreenDialog: true,
                              transition: Transition.cupertino,
                              BookmarkedPostsView(
                                controller: controller,
                              ),
                            );
                          },
                        ),
                        // ActionCardTitle(
                        //   title: 'Nachbarschaft',
                        // ),
                        // ActionCard(
                        //   title: 'Veranstaltungen',
                        //   icon: FlutterRemix.calendar_event_line,
                        //   onTap: () {
                        //     Get.snackbar("Pressed", "Pressed");
                        //   },
                        // ),
                        ActionCardTitle(
                          title: 'Einstellungen',
                        ),
                        ActionCard(
                          title: 'Profil Bearbeiten',
                          icon: FlutterRemix.user_settings_line,
                          onTap: () {
                            //get open settingfs page
                            Get.to(
                              fullscreenDialog: true,
                              transition: Transition.cupertino,
                              EditProfileView(),
                            );
                          },
                        ),
                        ActionCard(
                          title: 'Einstellungen',
                          icon: FlutterRemix.settings_3_line,
                          onTap: () {
                            //get open settingfs page
                            Get.to(
                              fullscreenDialog: true,
                              transition: Transition.cupertino,
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

class CheckAddressWithDeviceLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'CheckAddressWithDeviceLocation',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        print(FirebaseAuth.instance.currentUser);
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'checkAddressWithDeviceLocation',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 5),
          ),
        );
        try {
          // final send result address, deviceLongitudeCoordinate, deviceLatitudeCoordinate
          final HttpsCallableResult result =
              await callable.call(<String, dynamic>{
            'address': 'Wüstenrotstrasse 11, 4020 Linz, Austria',
            'deviceLongitudeCoordinate': 14.3029918272796,
            'deviceLatitudeCoordinate': 48.30083402501781,
          });
          // final HttpsCallableResult result =
          //     await callable.call(<String, dynamic>{
          //   'address': '0x8d1b9c1c5f0f5f0f5f0f5f0f5f0f5f0f5f0f5f0f',
          // });
          print(result.data);
        } catch (e) {
          print(e);
        }
      },
    );
  }
}

class GenerateVerificationCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'Generate Verification Code',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        if (FirebaseAuth.instance.currentUser != null) {
          // The user is signed in.
          print(FirebaseAuth.instance.currentUser);
        } else {
          // The user is not signed in.
          print("The user is not signed in.");
        }
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'generateVerificationCode',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 5),
          ),
        );
        try {
          final result = await callable.call(<String, dynamic>{});
          print('Verification code: ${result.data}');
          // show the code in a snaokbar
          Get.snackbar('Verification code', result.data.toString());
        } catch (error) {
          print('Error generating verification code: $error');
        }
      },
    );
  }
}

class GetDistanceFromLatLonInMeters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'getDistanceFromLatLonInMeters',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        const postId = 'hNZr1vDPmzTSA5oomzRi';

        if (FirebaseAuth.instance.currentUser != null) {
          // The user is signed in.
          print(FirebaseAuth.instance.currentUser);
        } else {
          // The user is not signed in.
          print("The user is not signed in.");
        }
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'getDistanceFromTwoUsers',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 5),
          ),
        );
        try {
          // rsult ist a string
          final result = await callable.call(<String, dynamic>{
            'postId': postId,
          });

          // // Use the distance value as needed
          // print('The distance between the users is: $distance meters');
          // // show the code in a snaokbar
          // print('The distance between the users is: ${result['data']} meters');
          // Get.snackbar('Meters', result.data);
          print('Distance: ${result.data}');
          Get.snackbar('Verification code', result.data.toString());
        } catch (error) {
          print('Error Flutter: $error');
        }
      },
    );
  }
}

class VerifyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String verificationCode = 'UTDSSp9nDi';
    final String address = "Wüstenrotstrasse 1, 4020 Linz, Austria";
    return LocooTextButton(
      label: 'Verify',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        // Call the verifyVerificationCode function
        final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'checkVerificationCode',
          // options: HttpsCallableOptions(
          //   timeout: const Duration(seconds: 5),
          // ),
        );
        try {
          final response = await callable.call({
            'verificationCode': verificationCode,
            'address': address,
          });
          // Handle successful response
          print(response.data);
        } catch (e) {
          // Handle error
          print(e);
        }
      },
    );
  }
}

class InviteNeighborCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(
            fullscreenDialog: true,
            transition: Transition.cupertino,
            InviteNeighborView(),
          );
        },
        child: Container(
          // add background color to the rounded container
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // return a rounded container with a icon on the left side and a text
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                child: Row(
                  children: [
                    //if icon is null then return a empty container else icon
                    Icon(
                      size: 22,
                      //if icon is null shwo nothing

                      FlutterRemix.share_box_fill,
                      color: Theme.of(context).primaryColor,
                      // color: Colors.black87,
                      // color: Colors.black,
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Nachbar einladen",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                              // letterSpacing: -0.1,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // return a arrow icon
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Icon(
                  FlutterRemix.arrow_right_s_line,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
