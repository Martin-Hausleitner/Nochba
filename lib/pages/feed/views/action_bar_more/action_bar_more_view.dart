
//import dart:ui
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/pages/auth/login_page.dart';
import 'package:locoo/shared/ui/buttons/locoo_text_button.dart';
import 'package:locoo/shared/ui/cards/action_card.dart';
import 'package:locoo/shared/ui/cards/action_card_title.dart';
import 'package:locoo/shared/ui/cards/action_text_card.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';
import 'package:locoo/shared/views/bottom_sheet_title_close_view.dart';

class ActionBarMore extends StatelessWidget {
  final String postID;
  final String userID;
  const ActionBarMore({
    Key? key,
    required this.postID,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(
      title: 'Mehr',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              ActionCard(
                title: 'Post melden',
                icon: FlutterRemix.flag_line,
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BottomSheetTitleCloseView(
                        title: 'Post Melden',
                        children: [
                          Padding(
                            padding: //right 15 left 15 bottom 5 top 1
                                const EdgeInsets.only(
                                    right: 15, left: 15, bottom: 5),
                            child: Column(
                              //align left
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //show 10 ActionCards
                                Text(
                                  'Wähle deinen Grund aus',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                //       .copyWith(
                                //           color: Theme.of(context)
                                //               .textTheme
                                //               .bodyText1!
                                //               .color!
                                //               .withOpacity(0.8)),
                                // ),
                                SizedBox(height: 5),

                                DropdownButtonExample(),
                                SizedBox(height: 10),

                                LocooTextField(
                                    maxLines: 10,
                                    height: 220,
                                    // controller:
                                    // controller.descriptionController,
                                    // textInputAction: TextInputAction.next,
                                    label: 'Beschreibung',
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? 'Enter a description'
                                            : null),
                                SizedBox(height: 10),
                                LocooTextButton(
                                  label: 'Post Melden',
                                  onPressed: () {},
                                  icon: FlutterRemix.flag_line,
                                ),
                                SizedBox(height: 10),

                                //),

                                // ActionCard(
                                //   title: 'Post bearbeiten',
                                //   onTap: () {
                                //     print('test');
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ActionCard(
                title: 'Post bearbeiten',
                icon: FlutterRemix.pencil_line,
                onTap: () {
                  print('test');
                },
              ),
              ActionCard(
                title: 'Post löschen',
                icon: FlutterRemix.delete_bin_line,
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialogDeletePost(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        // ActionCard(
        //     title: 'titlde',
        //     onTap: () {
        //       print('test');
        //     }),
      ],
    );
  }
}

const List<String> list = <String>['Spam', 'Nicht jugendfrei', 'Gewalt'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),
      child: Padding(
        padding: // left right 5 top 5 bottom 5
            const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
        child: DropdownButton<String>(
          value: dropdownValue,
          isExpanded: true,
          icon: const Icon(
            Icons.expand_more_outlined,
          ),
          // elevation: 16,
          style: TextStyle(
            // color: Theme.of(context).primaryColor,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          underline: Container(
            height: 0,
            // color: Theme.of(context).primaryColor,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AlertDialogDeletePost extends StatelessWidget {
  const AlertDialogDeletePost({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        //add round corner 20
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          //align center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add a red icon flutterremix error-warning-line
            Icon(
              FlutterRemix.error_warning_line,
              // color: Theme.of(context).colorScheme.error,
              color: Colors.red,
              size: 40,
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'Post löschen',
              //add fontwiehgt w500
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          'Bist du dir sicher, dass du diese Post löschen möchtest?',
          //style the text gray
          style: TextStyle(color: Color.fromARGB(133, 36, 36, 36)),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Abbrechen'),
                  child: const Text('Abbrechen'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Löschen'),
                  //style the button red
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                    // add round corner 20
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
