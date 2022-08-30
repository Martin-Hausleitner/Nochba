import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarSmallView extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AppBarSmallView(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
      // Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      body: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              title,
            ),
            leading: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  FlutterRemix.arrow_left_line,
                  size: 24,
                  color: Theme.of(context).buttonTheme.colorScheme?.primary,
                ),
                onPressed: () {
                  Get.back();
                },
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
            ),
            padding: EdgeInsetsDirectional.only(
              start: 12,
              end: 10,
            ),
            border: const Border(
              bottom: BorderSide(color: Colors.transparent),
            ),
          ),
          // add a Silverlist with SettingsCard
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
