import 'dart:convert';
import 'dart:io';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:simplytranslate/simplytranslate.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/pages/private_profile/views/own_posts_view.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:nochba/logic/models/user.dart' as models;

import 'package:nochba/logic/auth_access.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/cards/action_card_title.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'private_profile_controller.dart';
import 'views/bookmarked_posts_view.dart';
import 'views/edit_profile_view.dart';
import 'views/invite_neighbor_view.dart';
import 'views/settings_view.dart';
import 'widgets/logout_settings_cart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';
// import 'package:add_2_calendar/add_2_calendar.dart';

class PrivateProfilePage extends GetView<PrivateProfileController> {
  const PrivateProfilePage({super.key});

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
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                AppLocalizations.of(context)!.yourProfile,
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
                        const SizedBox(
                          height: 20,
                        ),

                        Center(
                          child: FutureBuilder<models.User?>(
                            future: controller.getCurrentUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return Column(
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
                                            // return Text(
                                            //   'Der Name kann zurzeit nicht geladen werden',
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .titleLarge
                                            //       ?.copyWith(
                                            //         // fontSize: 30,
                                            //         fontWeight: FontWeight.w700,
                                            //         letterSpacing: -0.3,
                                            //         color: Theme.of(context)
                                            //             .colorScheme
                                            //             .onSecondaryContainer,
                                            //       ),
                                            // );
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
                                    const SizedBox(
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
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          data.suburb ?? '',
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
                                );
                              } else if (snapshot.hasError) {
                                // return a red info icon whith a text below with the error
                                return Text(
                                  AppLocalizations.of(context)!
                                      .usernameCannotBeLoaded,
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
                              } else {
                                return LoadingProfileName();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ActionCardTitle(
                        //   title: 'Dein Profil',
                        // ),
                        const InviteNeighborCard(),
                        //button
                        // if (kDebugMode) NewWidget(),

                        // const FeedbackTest(),
                        // if (kDebugMode) TranslationWidget(),
                        // // GetDistanceFromLatLonInMeters(),
                        // // VerifyButton(),
                        ActionCard(
                          title:
                              AppLocalizations.of(context)!.yourPublicProfile,
                          icon: FlutterRemix.user_line,
                          onTap: () => controller.pushPublicProfileView(),
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.yourPosts,
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
                          title: AppLocalizations.of(context)!.yourSavedPosts,
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
                          title: AppLocalizations.of(context)!.settings,
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.editProfile,
                          icon: FlutterRemix.user_settings_line,
                          onTap: () {
                            //get open settingfs page
                            Get.to(
                              fullscreenDialog: true,
                              transition: Transition.cupertino,
                              const EditProfileView(),
                            );
                          },
                        ),
                        ActionCard(
                          title: AppLocalizations.of(context)!.settings,
                          icon: FlutterRemix.settings_3_line,
                          onTap: () {
                            //get open settingfs page
                            Get.to(
                              fullscreenDialog: true,
                              transition: Transition.cupertino,
                              const SettingsView(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        LogoutSettingsCard(
                          onTap: () async => await controller.signOut(),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        if (kDebugMode)
                          SizedBox(
                            height: 300,
                          ),
                        if (kDebugMode) CheckAddressWithDeviceLocation(),
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

class NewWidget extends StatelessWidget {
  const NewWidget({Key? key}) : super(key: key);

  Event buildEvent({Recurrence? recurrence}) {
    return Event(
      title: 'Test event',
      description: 'example',
      location: 'Flutter app',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(minutes: 30)),
      allDay: false,
      iosParams: IOSParams(
        reminder: Duration(minutes: 40),
        url: "http://example.com",
      ),
      androidParams: AndroidParams(
        emailInvites: ["test@example.com"],
      ),
      recurrence: recurrence,
    );
  }

  Future<void> _handleAddToCalendar() async {
    // Request calendar permission
    final PermissionStatus permissionStatus =
        await Permission.calendar.request();
    if (permissionStatus != PermissionStatus.granted) {
      // Permission denied, do not add event to calendar
      print("Permission denied");
      return;
    }

    try {
      // Add event to calendar
      await Add2Calendar.addEvent2Cal(
        buildEvent(),
      );

      print("Event added to calendar");
    } catch (e) {
      print("Error adding event to calendar: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text("Add to Calendar"),
      onPressed: _handleAddToCalendar,
    );
  }
}

class LoadingProfileName extends StatelessWidget {
  const LoadingProfileName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.onSurface,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.035),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 170,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.035),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 120,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.035),
            ),
          ),
        ],
      ),
    );
  }
}

// class FeedbackTest extends StatelessWidget {
//   const FeedbackTest({
//     super.key,
//   });

//   @override
//   Future<void> uploadDataToTrello(String text, var screenshot) async {
//     var apiKey = Platform.environment['TRELLO_API_KEY'];
//     var token = Platform.environment['TRELLO_TOKEN'];
//     var boardId = Platform.environment['TRELLO_BOARD_ID'];
//     var listId = Platform.environment['TRELLO_LIST_ID'];

//     apiKey = dotenv.env['TRELLO_API_KEY'];
//     token = dotenv.env['TRELLO_TOKEN'];
//     boardId = dotenv.env['TRELLO_BOARD_ID'];
//     listId = dotenv.env['TRELLO_LIST_ID'];

//     var packageInfo = await PackageInfo.fromPlatform();
//     var version = packageInfo.version;
//     var buildNumber = packageInfo.buildNumber;
//     var cardId;

//     var name = "v$version+$buildNumber | $text";

//     var url1 = Uri.parse(
//         "https://api.trello.com/1/cards?key=$apiKey&token=$token&idList=$listId&name=$name&desc=$text");

//     try {
//       var response1 = await http.post(url1);
//       if (response1.statusCode == 200) {
//         var responseJson = json.decode(response1.body);
//         cardId = responseJson["id"];
//         print("Card ID: $cardId");
//       } else {
//         throw Exception(
//             "Failed to retrieve card ID: ${response1.statusCode}${response1.reasonPhrase}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }

//     name = "Screenshot.png";

//     var url = Uri.parse(
//         "https://api.trello.com/1/cards/$cardId/attachments?key=$apiKey&token=$token&name=$name&setCover=true");

//     var request = http.MultipartRequest('POST', url);
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'file',
//         screenshot,
//         filename: name,
//         contentType: MediaType('image', 'png'),
//       ),
//     );

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print("Data successfully uploaded to Trello");
//     } else {
//       throw Exception(
//           "Failed to upload data to Trello${response.statusCode}${response.reasonPhrase}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () async {
//         var packageInfo = await PackageInfo.fromPlatform();
//         var appName = packageInfo.appName;
//         var packageName = packageInfo.packageName;
//         var version = packageInfo.version;
//         var buildNumber = packageInfo.buildNumber;
//         var test = packageInfo.toString();
//         print("$appName $packageName $version $buildNumber");
//         // uploadDataToTrello(
//         //   "Test",
//         //   null,
//         // );

//         BetterFeedback.of(context).show(
//           (UserFeedback feedback) async {
//             print(feedback.text);
//             uploadDataToTrello(feedback.text, feedback.screenshot);
//           },
//         );
//       },
//       child: const Text("Test Feedback"),
//     );
//   }
// }

class CheckAddressWithDeviceLocation extends StatelessWidget {
  const CheckAddressWithDeviceLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: '[DEV] Click to verify account',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        print(FirebaseAuth.instance.currentUser);
        final HttpsCallable callable = FirebaseFunctions.instanceFor(
          region: 'europe-west1',
        ).httpsCallable(
          'checkAddressWithDeviceLocation',
        );
        // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        //   'checkAddressWithDeviceLocation',
        //   options: HttpsCallableOptions(
        //     timeout: const Duration(seconds: 5),
        //   ),
        // );
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
  const GenerateVerificationCode({super.key});

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
          // options: HttpsCallableOptions(
          //   timeout: const Duration(seconds: 5),
          // ),
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
  const GetDistanceFromLatLonInMeters({super.key});

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
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    const String verificationCode = 'UTDSSp9nDi';
    const String address = "Wüstenrotstrasse 1, 4020 Linz, Austria";
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
  const InviteNeighborCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(
            fullscreenDialog: true,
            transition: Transition.cupertino,
            const InviteNeighborView(),
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
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        AppLocalizations.of(context)!.inviteNeighbor,
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

// class TranslationWidget extends StatefulWidget {
//   @override
//   _TranslationWidgetState createState() => _TranslationWidgetState();
// }

// class _TranslationWidgetState extends State<TranslationWidget> {
//   final gt = SimplyTranslator(EngineType.google);

//   String _germanText = "Er läuft schnell.";
//   String _translatedText = "";
//   bool _showOriginal = true;
//   bool _loading = false;
//   int _retryCount = 0;

//   void _translateText() {
//     setState(() {
//       _showOriginal = !_showOriginal;
//     });

//     if (!_showOriginal) {
//       _translateTextAsync();
//     }
//   }

//   void _translateTextAsync() async {
//     if (mounted) {
//       setState(() {
//         _loading = true;
//       });
//       try {
//         Translation libTranslate = await gt.translateSimply(_germanText);
//         _translatedText = libTranslate.translations.text;
//         if (mounted) {
//           setState(() {
//             _loading = false;
//           });
//         }
//       } catch (e) {
//         if (_retryCount < 2) {
//           setState(() {
//             _retryCount++;
//             print("retrying");
//           });
//           _translateTextAsync();
//         } else {
//           if (mounted) {
//             setState(() {
//               _loading = false;
//             });
//           }
//         }
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _translateText();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _loading
//             ? CircularProgressIndicator()
//             : Text(_showOriginal ? _germanText : _translatedText),
//         TextButton(
//           child: Text("Translate"),
//           onPressed: _translateText,
//         ),
//       ],
//     );
//   }
// }
