// ignore_for_file: deprecated_member_use

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
// import '../settings/settings_page.dart';
import 'public_profile_controller.dart';
import 'widgets/profile_content.dart';
import 'widgets/public_profile_more_view.dart';

class PublicProfileView extends StatelessWidget {
  final String authorName;
  final String authorImage;

  const PublicProfileView({
    Key? key,
    this.authorName = 'John Doe',
    this.authorImage = 'https://i.pravatar.cc/303',
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
            FlutterRemix.arrow_left_line,
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
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0))),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return
                        // height of the modal bottom sheet
                        PublicProfileMoreView(
                      userID: 'lol',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        //align centet
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // create a stack with an CircleAvatar with a photo and in the right bottom corner a small circle with a edit icon in it
          SizedBox(
            height: 8,
          ),
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(
                authorImage,
              ),
            ),
          ),

          // show a name
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              authorName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            //center
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 4),
                // show this svg:
                child: Icon(
                  FlutterRemix.map_pin_line,
                  size: 12,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
              ),
              Text(
                'Auwiesen',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 24,
              left: 18,
              right: 18,
            ),
            child: LocooTextButton(
              icon: FlutterRemix.chat_1_fill,
              label: 'Anschreiben',
              //onpres open Get.Snackbar
              onPressed: () {
                Get.snackbar(
                  'Anschreiben',
                  'Du hast den Button gedrückt',
                );
              },
            ),
          ),

          SizedBox(
            height: 12,
          ),

          ProfileContent(),

          // add a tabbarview

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
