import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBigView extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final List<Widget> children;

  const AppBarBigView(
      {super.key,
      required this.title,
      required this.children,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle:
              Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
          navLargeTitleTextStyle:
              Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    // color: Theme.of(context).colorScheme.onSecondaryContainer,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
        ),
        barBackgroundColor: backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        // Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        body: CustomScrollView(
          //disable scroll bar

          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                title,
              ),
              leading: Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 0.01,
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
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 18),
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
      ),
    );
  }
}
