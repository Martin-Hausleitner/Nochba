// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
// import '../settings/settings_page.dart';
import 'public_profile_controller.dart';
import 'widgets/profile_content.dart';
import 'widgets/public_profile_more_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PublicProfileView extends GetView<PublicProfileController> {
  final String userId;

  const PublicProfileView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          // title: const Text('Dein Profil', style: TextStyle(color: Colors.black)),
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
          leading: IconButton(
            splashRadius: 0.001,
            icon: Icon(
              Icons.close_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            //onPress open SettingsPage
            // got back to he previes screen
            onPressed: () {
              Get.back();
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                splashRadius: 0.001,

                icon: Icon(
                  FlutterRemix.more_line,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                //onPress open SettingsPage
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return
                          // height of the modal bottom sheet
                          PublicProfileMoreView(
                              controller: controller, userId: userId);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<User?>(
          future: controller.getUser(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('The public profile could not be loaded'));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return Column(
                //align centet
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // create a stack with an CircleAvatar with a photo and in the right bottom corner a small circle with a edit icon in it
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        user.imageUrl!,
                      ),
                    ),
                  ),

                  // show a name
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      user.fullName ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    //center
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        user.suburb ?? '---',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.5),
                            ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        'assets/icons/housing_distance.svg',
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.55),
                        height: 16,
                        semanticsLabel: 'A red up arrow',
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Row(
                        children: [
                          FutureBuilder<String>(
                            future: controller.getDistanceToUser(userId),
                            builder: (context, snapshot) {
                              String distance = '';
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                distance = '';
                              } else if (snapshot.hasData) {
                                distance = snapshot.data!;
                              } else {
                                distance = '---';
                              }

                              return Text(
                                distance,
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
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (controller.shouldShowWriteToButton(user.id))
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 18,
                        right: 18,
                      ),
                      child: LocooTextButton(
                        icon: FlutterRemix.chat_1_fill,
                        label: AppLocalizations.of(context)!.sendMessage,
                        //onpres open Get.Snackbar
                        onPressed: () async =>
                            await controller.sendNotification(user.id),
                      ),
                    ),

                  const SizedBox(
                    height: 12,
                  ),

                  ProfileContent(controller: controller, userId: userId),

                  // add a tabbarview

                  // add TabBarView with with info and post
                ],
              );
            } else {
              return Container();
            }
          },
        ));
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
