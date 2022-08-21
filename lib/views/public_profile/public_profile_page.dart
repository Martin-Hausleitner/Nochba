// ignore_for_file: deprecated_member_use

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/shared/round_icon_button.dart';

import '../../shared/button.dart';
import '../settings/settings_page.dart';
import 'public_profile_controller.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text('Dein Profil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            FlutterRemix.arrow_left_line,
            color: Colors.black,
          ),
          //onPress open SettingsPage
          // got back to he previes screen
          onPressed: () {
            Get.back();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FlutterRemix.more_line,
              color: Colors.black,
            ),
            //onPress open SettingsPage
            onPressed: () {
              //opne snackbar
              Get.snackbar(
                "Settings",
                "This is a snackbar",
              );
            },
          ),
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Button(
              icon: FlutterRemix.account_box_fill,
              text: 'Anschreiben',
              //onpres open Get.Snackbar
              onPressed: () {
                Get.snackbar(
                  'Anschreiben',
                  'Du hast den Button gedrückt',
                );
              },
            ),
          ),

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
