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
                  print('test');
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
