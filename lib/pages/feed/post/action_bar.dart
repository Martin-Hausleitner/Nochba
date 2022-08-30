import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:locoo/shared/ui/buttons/round_icon_button.dart';


//create a ActionBar class which have multiple round icon Buttons

class ActionBar extends StatelessWidget {
  const ActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return a row with round icon buttons and a text
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
          RoundIconButton(
            icon: Icons.thumb_up,
            onPressed: () {
              Get.snackbar(
                "Edit",
                "Edit your profile",
              );
            },
          ),
          // add a gray Text
          Padding(
            padding: EdgeInsets.only(left: 8, right: 18),
            child: Text(
              '14',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),

          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
          RoundIconButton(
            icon: Icons.forum,
            onPressed: () {
              Get.snackbar(
                "Edit",
                "Edit your profile",
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 18),
            child: Text(
              '14',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
          RoundIconButton(
            icon: Icons.bookmark,
            onPressed: () {
              Get.snackbar(
                "Edit",
                "Edit your profile",
              );
            },
          ),
          Spacer(),
          RoundIconButton(
            icon: Icons.more_horiz,
            onPressed: () {
              Get.snackbar(
                "Edit",
                "Edit your profile",
              );
            },
          ),

          // add a row with aliged left with a RoundIconButton

          // return a round icon button with a icon of Icons.favorite and a color of Colors.red
        ],
      ),
    );
  }
}
