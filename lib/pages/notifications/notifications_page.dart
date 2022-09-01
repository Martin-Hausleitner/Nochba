import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:locoo/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';

import 'notifications_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
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
              // padding: EdgeInsetsDirectional.only(
              //   start: 7,
              //   end: 23,
              // ),

              // leading: Icon(CupertinoIcons.person_2),
              // This title is visible in both collapsed and expanded states.
              // When the "middle" parameter is omitted, the widget provided
              // in the "largeTitle" parameter is used instead in the collapsed state.
              largeTitle: Text(
                'Aktivitäten',
              ),

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
                      Get.snackbar('title', 'message');
                    },
                  )),
              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // This widget fills the remaining space in the viewport.
            // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  LocooCircularIconButton(
                    iconData: FlutterRemix.close_line,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.05),
                    iconColor: Colors.black,
                    radius: 32,
                    onPressed: () => Navigator.pop(context),
                  ),

                  LocooCircularIconButton(
                    iconData: Icons.remove,
                    fillColor: Colors.red,
                    iconColor: Colors.white,
                    radius: 32,
                    onPressed: () {},
                  ),
                  LocooCircularIconButton(
                    iconData: Icons.add,
                    fillColor: Colors.green,
                    iconColor: Colors.white,
                    radius: 48,
                    onPressed: () {},
                  ),
                  LocooCircularIconButton(
                    iconData: Icons.check,
                    iconColor: Colors.green,
                    outlineColor: Colors.green,
                    onPressed: () {},
                  ),
                  SimpleElevatedButtonWithIcon(
                    label: const Text("Done"),
                    iconData: Icons.check,
                    color: Colors.green,
                    onPressed: () {},
                  ),

                  // create a button with  HapticFeedback.lightImpact();
                  LocooTextButton(
                    label: 'HapticFeedback.lightImpact()',
                    icon: Icons.check,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  LocooTextButton(
                    label: 'HapticFeedback.heavyImpact();',
                    icon: Icons.check,
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                    },
                  ),
                  LocooTextButton(
                    label: 'mediumImpact()',
                    icon: Icons.check,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                    },
                  ),
                  LocooTextButton(
                    label: 'selectionClick(',
                    icon: Icons.check,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                    },
                  ),
                  LocooTextButton(
                    label: 'vibrate()',
                    icon: Icons.check,
                    onPressed: () {
                      HapticFeedback.vibrate();
                    },
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
