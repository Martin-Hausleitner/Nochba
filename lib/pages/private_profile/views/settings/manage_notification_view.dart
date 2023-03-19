import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/private_profile/views/settings/manage_account_controller.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/cards/action_text_card_red.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';

class ManageNotificationView extends GetView<ManageAccountController> {
  const ManageNotificationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: AppLocalizations.of(context)!.notifications,
      onPressed: () => {Get.back()},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5, left: 15, right: 9, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.chatRequests,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            // letterSpacing: -0.1,
                          ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: StreamBuilder<bool?>(
                      stream: controller.getPermReqBeforeChatOfCurrentUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return CupertinoSwitch(
                            activeColor: Theme.of(context).primaryColor,
                            value: data,
                            onChanged: (value) async => await controller
                                .updatePermReqBeforeChatOfCurrentUser(value),
                          );
                        } else {
                          return CupertinoSwitch(
                            activeColor: Theme.of(context).disabledColor,
                            value: true,
                            onChanged: (value) {
                              Get.snackbar('Not Possible',
                                  'Switching is currently not possible');
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            AppLocalizations.of(context)!.whenYouGenerateANewInvitationCodeTheOldOneBecomesInvalid,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        // ActionTextCard(
        //   title: 'Email',
        //   icon: const Icon(FlutterRemix.user_line),
        //   onTap: () {
        //     Get.snackbar(
        //         "Email ändern", "Diese Funktion ist noch nicht verfügbar");
        //     // showModalBottomSheet<void>(
        //     //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     //   shape: RoundedRectangleBorder(
        //     //       borderRadius:
        //     //           BorderRadius.vertical(top: Radius.circular(25.0))),
        //     //   context: context,
        //     //   isScrollControlled: true,
        //     //   builder: (BuildContext context) {
        //     //     return BottomSheetCloseSaveView(
        //     //       onSave: () {},
        //     //       children: [
        //     //         LocooTextField(
        //     //           label: 'Email',
        //     //           autofocus: true,
        //     //           controller: TextEditingController(text: 'test@test.at'),
        //     //         ),
        //     //         SizedBox(height: 10),
        //     //         SizedBox(
        //     //           height: 15,
        //     //         ),
        //     //       ],
        //     //     );
        //     //   },
        //     // );
        //   },
        //   text: 'Test@test.at',
        // ),
        // ActionTextCard(
        //   title: 'Passwort',
        //   icon: const Icon(FlutterRemix.user_line),
        //   onTap: () {
        //     Get.snackbar(
        //         "Passwort ändern", "Diese Funktion ist noch nicht verfügbar");

        //     // showModalBottomSheet<void>(
        //     //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     //   shape: RoundedRectangleBorder(
        //     //       borderRadius:
        //     //           BorderRadius.vertical(top: Radius.circular(25.0))),
        //     //   context: context,
        //     //   isScrollControlled: true,
        //     //   builder: (BuildContext context) {
        //     //     return BottomSheetCloseSaveView(
        //     //       onSave: () {},
        //     //       children: [
        //     //         LocooTextField(
        //     //           label: 'Passwort',
        //     //           autofocus: true,
        //     //           controller: TextEditingController(text: 'test'),
        //     //         ),
        //     //         SizedBox(height: 10),
        //     //         SizedBox(
        //     //           height: 15,
        //     //         ),
        //     //       ],
        //     //     );
        //     //   },
        //     // );
        //   },
        //   text: '⦁⦁⦁⦁⦁⦁⦁⦁⦁',
        // ),
        // ActionTextCard(
        //   title: 'Adresse',
        //   icon: const Icon(FlutterRemix.user_line),
        //   onTap: () {
        //     // show me a alert that now you cant change your address
        //     Get.snackbar(
        //         "Adresse ändern", "Diese Funktion ist noch nicht verfügbar");

        //     // showModalBottomSheet<void>(
        //     //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     //   shape: RoundedRectangleBorder(
        //     //       borderRadius:
        //     //           BorderRadius.vertical(top: Radius.circular(25.0))),
        //     //   context: context,
        //     //   isScrollControlled: true,
        //     //   builder: (BuildContext context) {
        //     //     return BottomSheetCloseSaveView(
        //     //       onSave: () {},
        //     //       children: [
        //     //         LocooTextField(
        //     //           label: 'Straße',
        //     //           autofocus: true,
        //     //           controller: TextEditingController(text: 'Teststraße'),
        //     //         ),
        //     //         SizedBox(height: 10),
        //     //         LocooTextField(
        //     //           label: 'Stadt',
        //     //           autofocus: true,
        //     //           controller: TextEditingController(text: 'Linz'),
        //     //         ),
        //     //         SizedBox(height: 10),
        //     //         LocooTextField(
        //     //           label: 'Postleitzahl',
        //     //           autofocus: true,
        //     //           controller: TextEditingController(text: '4020'),
        //     //         ),
        //     //         SizedBox(height: 10),
        //     //         SizedBox(
        //     //           height: 15,
        //     //         ),
        //     //       ],
        //     //     );
        //     //   },
        //     // );
        //   },
        //   text: 'Gutenbergstraße 1, 1234 Wien',
        // ),
        // const SizedBox(height: 30),
        // ActionTextCardRed(
        //   title: 'Account löschen',
        //   icon: const Icon(FlutterRemix.user_line),
        //   onTap: () => showDialog<String>(
        //     context: context,
        //     builder: (BuildContext context) => AlertDialogDeleteAccount(
        //       onDelete: controller.deleteAccount,
        //     ),
        //   ),
        //   text: '',
        // ),
      ],
    );
  }
}
