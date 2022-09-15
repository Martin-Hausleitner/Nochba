import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/shared/ui/cards/action_card.dart';
import 'package:locoo/shared/ui/cards/action_card_title.dart';
import 'package:locoo/shared/ui/cards/action_text_card.dart';
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
                        title: 'Melden',
                        children: [
                          Padding(
                            padding: //right 15 left 15 bottom 5 top 1
                                const EdgeInsets.only(
                                    right: 15, left: 15, bottom: 5),
                            child: Column(
                              children: [
                                //show 10 ActionCards
                                ActionCard(
                                  title: 'Spam',
                                  onTap: () {
                                    showModalBottomSheet<dynamic>(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return BottomSheetTitleCloseView(
                                          title: 'Melden',
                                          children: [
                                            Padding(
                                              padding: //right 15 left 15 bottom 5 top 1
                                                  const EdgeInsets.only(
                                                      right: 15,
                                                      left: 15,
                                                      bottom: 5),
                                              child: Column(
                                                children: [],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),

                                //),
                                ActionCard(
                                  title: 'Nicht jugendfrei',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ActionCard(
                                  title: 'Gewalt',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),

                                ActionCard(
                                  title: 'Nicht jugendfrei',
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),

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
                onTap: () {
                  print('test');
                },
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
