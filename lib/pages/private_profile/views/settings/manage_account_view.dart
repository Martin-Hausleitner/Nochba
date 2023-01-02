import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/cards/action_text_card_red.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:nochba/shared/views/bottom_sheet_close_save_view.dart';

class ManageAccountView extends StatelessWidget {
  const ManageAccountView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Konto Verwalten',
      onPressed: () => {Get.back()},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        ActionTextCard(
          title: 'Email',
          icon: Icon(FlutterRemix.user_line),
          onTap: () {
            Get.snackbar(
                "Email ändern", "Diese Funktion ist noch nicht verfügbar");
            // showModalBottomSheet<void>(
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   shape: RoundedRectangleBorder(
            //       borderRadius:
            //           BorderRadius.vertical(top: Radius.circular(25.0))),
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (BuildContext context) {
            //     return BottomSheetCloseSaveView(
            //       onSave: () {},
            //       children: [
            //         LocooTextField(
            //           label: 'Email',
            //           autofocus: true,
            //           controller: TextEditingController(text: 'test@test.at'),
            //         ),
            //         SizedBox(height: 10),
            //         SizedBox(
            //           height: 15,
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
          text: 'Test@test.at',
        ),
        ActionTextCard(
          title: 'Passwort',
          icon: Icon(FlutterRemix.user_line),
          onTap: () {
            Get.snackbar(
                "Passwort ändern", "Diese Funktion ist noch nicht verfügbar");

            // showModalBottomSheet<void>(
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   shape: RoundedRectangleBorder(
            //       borderRadius:
            //           BorderRadius.vertical(top: Radius.circular(25.0))),
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (BuildContext context) {
            //     return BottomSheetCloseSaveView(
            //       onSave: () {},
            //       children: [
            //         LocooTextField(
            //           label: 'Passwort',
            //           autofocus: true,
            //           controller: TextEditingController(text: 'test'),
            //         ),
            //         SizedBox(height: 10),
            //         SizedBox(
            //           height: 15,
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
          text: '⦁⦁⦁⦁⦁⦁⦁⦁⦁',
        ),
        ActionTextCard(
          title: 'Adresse',
          icon: Icon(FlutterRemix.user_line),
          onTap: () {
            // show me a alert that now you cant change your address
            Get.snackbar(
                "Adresse ändern", "Diese Funktion ist noch nicht verfügbar");

            // showModalBottomSheet<void>(
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   shape: RoundedRectangleBorder(
            //       borderRadius:
            //           BorderRadius.vertical(top: Radius.circular(25.0))),
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (BuildContext context) {
            //     return BottomSheetCloseSaveView(
            //       onSave: () {},
            //       children: [
            //         LocooTextField(
            //           label: 'Straße',
            //           autofocus: true,
            //           controller: TextEditingController(text: 'Teststraße'),
            //         ),
            //         SizedBox(height: 10),
            //         LocooTextField(
            //           label: 'Stadt',
            //           autofocus: true,
            //           controller: TextEditingController(text: 'Linz'),
            //         ),
            //         SizedBox(height: 10),
            //         LocooTextField(
            //           label: 'Postleitzahl',
            //           autofocus: true,
            //           controller: TextEditingController(text: '4020'),
            //         ),
            //         SizedBox(height: 10),
            //         SizedBox(
            //           height: 15,
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
          text: 'Gutenbergstraße 1, 1234 Wien',
        ),
        SizedBox(height: 30),
        ActionTextCardRed(
          title: 'Account löschen',
          icon: Icon(FlutterRemix.user_line),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialogDeleteAccount(),
          ),
          text: '',
        ),
      ],
    );
  }
}

class AlertDialogDeleteAccount extends StatelessWidget {
  const AlertDialogDeleteAccount({
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
              'Account löschen',
              //add fontwiehgt w500
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          'Lösche deinen Account für immer bei Locoo. Die Daten können nicht wiederhergestellt werden.',
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
