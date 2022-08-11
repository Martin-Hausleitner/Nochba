import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

//create a class which have a rounded container with a icon on the left side and a text and on the right side a arrow icon
class LogoutSettingsCard extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutSettingsCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // add background color to the rounded container
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
                    Icon(
                      FlutterRemix.logout_box_r_line,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Abmelden",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
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
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
