import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
//create a class calles InviteNeighborView which have AppBarBigView

class InviteNeighborView extends StatelessWidget {
  const InviteNeighborView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Nachbar einladen',
      onPressed: () => {Get.back()},
      // backgroundColor: Theme.of(context).colorScheme.surface,
      // contentPadding: EdgeInsets.zero,
      // return a rounded container with a icon on the left side and a text
      children: [
        Row(
          //center
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Dein Einladungscode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      child: QrImage(
                        data: 'https://nochba.de',
                        version: QrVersions.auto,
                        size: 150.0,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: "123456789"));
                        //show snackbar
                        Get.snackbar(
                            'Einladungscode wurde kopiert', '123456789');
                        // copied successfully
                      },
                      child: Row(
                        // center
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('123456789'),
                          SizedBox(width: 5),
                          //icon copy
                          Icon(
                            color: Theme.of(context).colorScheme.onSurface,
                            FlutterRemix.file_copy_2_line,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // add background color to the rounded container
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ActionCard(
          title: 'Einladungscode teilen',
          icon: FlutterRemix.share_box_line,
          onTap: () {
            Share.share('check out my website https://example.com',
                subject: 'Look what I made!');
          },
        ),
        LocooTextButton(
          label: "Neuen Einlade Code generieren",
          onPressed: () {
            // HapticFeedback.lightImpact();
            // onTap();
          },
          icon: FlutterRemix.refresh_line,
        ),
        //padding top left right bottom 10
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Wenn du einen neuen Einladungscode generierst, wird der alte ungültig.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
