import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String font = "SanFrancisco";
    final double size = 20.0;
    final double height = 45.0;

    // return a contianer with a title, a sizedbox, a widped Clip
    return Container(
      child: ListView(
        //align left
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 18,
                ),
                Text(
                  'Interessen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        //use the font of the theme
                        fontWeight: FontWeight.w500,
                      ),
                ),
                // create a text with weigh t900
                SizedBox(
                  height: 14,
                ),
                Wrap(
                    // space between chips
                    spacing: 6,
                    runSpacing: 7,
                    // list of chips
                    children: const [
                      UserInfoClip(
                        text: "Halfsdflooo",
                      ),
                      UserInfoClip(
                        text: "Hallooo",
                      ),
                      UserInfoClip(
                        text: "Hallosfddsfoo",
                      ),
                      UserInfoClip(
                        text: "Hallsfsooo",
                      ),
                    ]),
                SizedBox(
                  height: 18,
                ),

                Text(
                  'Bietet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: 14,
                ),
                Wrap(
                    // space between chips
                    spacing: 6,
                    runSpacing: 7,
                    // list of chips
                    children: const [
                      UserInfoClip(
                        text: "Halfsdflooo",
                      ),
                      UserInfoClip(
                        text: "Hallooo",
                      ),
                      UserInfoClip(
                        text: "Hallosfddsfoo",
                      ),
                      UserInfoClip(
                        text: "Hallsfsooo",
                      ),
                    ]),
                SizedBox(
                  height: 18,
                ),
                Text(
                  'Basis Info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: 14,
                ),
                // create a row tith a colum with a icon and a text
                BaseInfoRow(
                    data: '11.11.1111',
                    icon: FlutterRemix.cake_2_line,
                    title: 'Geburtstag: '),
                SizedBox(
                  height: 2,
                ),
                BaseInfoRow(
                    data: '11.11.1111',
                    icon: FlutterRemix.history_line,
                    title: 'In der Nachbarschaft seit: '),
                SizedBox(
                  height: 2,
                ),
                BaseInfoRow(
                    data: '11.11.1111',
                    icon: FlutterRemix.briefcase_4_line,
                    title: 'Beruf: '),
                SizedBox(
                  height: 2,
                ),
                BaseInfoRow(
                    data: '11.11.1111',
                    icon: FlutterRemix.group_line,
                    title: 'Familienstand: '),
                SizedBox(
                  height: 2,
                ),
                BaseInfoRow(
                    data: '11.11.1111',
                    icon: Icons.pets_outlined,
                    title: 'Haustiere: '),

                SizedBox(
                  height: 18,
                ),
                Text(
                  'Mehr über mich',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, eget consectetur nisi nisi eget nisi. Nam euismod, nisi eu consectetur consectetur, nisi nisi consectetur nisi, e',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6)),
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BaseInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  const BaseInfoRow(
      {super.key, required this.icon, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 17,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          data,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6)),
        ),
      ],
    );
  }
}

class UserInfoClip extends StatelessWidget {
  final String text;

  const UserInfoClip({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),

      // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      // add a border 1
      shape: StadiumBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // color: Colors.transparent,
              width: 1)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
