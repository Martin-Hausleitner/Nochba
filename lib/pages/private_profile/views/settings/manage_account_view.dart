import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/private_profile/views/settings/manage_account_controller.dart';
import 'package:nochba/shared/ui/buttons/text_field_remove_text_button.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/cards/action_text_card_red.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:nochba/shared/views/bottom_sheet_close_save_view.dart';

class ManageAccountView extends GetView<ManageAccountController> {
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
        FutureBuilder<String?>(
          future: controller.getEmailOfCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final email = snapshot.data!;
              return ActionTextCard(
                title: 'Email',
                icon: const Icon(FlutterRemix.user_line),
                onTap: () {
                  showModalBottomSheet<void>(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BottomSheetCloseSaveView(
                        onSave: () async =>
                            await controller.updateEmailOfCurrentUser(),
                        children: [
                          Form(
                            key: controller.emailKey,
                            child: Column(
                              children: [
                                LocooTextField(
                                  label: 'Neue Email eingeben',
                                  suffixIcon: TextFieldRemoveTextButton(
                                    onPressed: () =>
                                        controller.emailTextController.clear(),
                                  ),
                                  autofocus: true,
                                  controller:
                                      controller.getEmailTextController(email),
                                  validator: controller.validateEmail,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                text: email,
              );
            } else {
              return ActionTextCard(
                title: 'Email',
                icon: const Icon(FlutterRemix.user_line),
                onTap: () {
                  Get.snackbar("Email nicht aufrufbar",
                      "Ihre Email ist im Moment nicht aufrufbar");
                },
                text: 'Derzeit nicht verfügbar',
              );
            }
          },
        ),
        ActionTextCard(
          title: 'Passwort',
          icon: const Icon(FlutterRemix.user_line),
          onTap: () {
            showModalBottomSheet<void>(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return BottomSheetCloseSaveView(
                  onSave: () async =>
                      await controller.updatePasswordOfCurrentUser(),
                  children: [
                    Form(
                      key: controller.passwordKey,
                      child: Column(
                        children: [
                          LocooTextField(
                            label: 'Neues Passwort eingeben',
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            controller: controller.firstPasswordTextController,
                            validator: controller.validatePassword,
                            autovalidateMode: AutovalidateMode.disabled,
                            suffixIcon: TextFieldRemoveTextButton(
                              onPressed: () => controller
                                  .firstPasswordTextController
                                  .clear(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          LocooTextField(
                            label: 'Erneut neues Passwort eingeben',
                            textInputAction: TextInputAction.done,
                            controller: controller.secondPasswordTextController,
                            validator: controller.validatePassword,
                            autovalidateMode: AutovalidateMode.disabled,
                            suffixIcon: TextFieldRemoveTextButton(
                              onPressed: () => controller
                                  .secondPasswordTextController
                                  .clear(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
          text: '⦁⦁⦁⦁⦁⦁',
        ),
        ActionTextCard(
          title: 'Adresse',
          icon: const Icon(FlutterRemix.user_line),
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
        const SizedBox(height: 30),
        ActionTextCardRed(
          title: 'Account löschen',
          icon: const Icon(FlutterRemix.user_line),
          onTap: () async => await controller.onDeleteAccountTap(context),
          text: '',
        ),
      ],
    );
  }
}

class AlertDialogDeleteAccount extends StatelessWidget {
  const AlertDialogDeleteAccount({Key? key, required this.onDelete})
      : super(key: key);

  final Future Function() onDelete;

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
          children: const [
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
            Text(
              'Account löschen',
              //add fontwiehgt w500
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          'Lösche deinen Account für immer bei Nochba. Die Daten können nicht wiederhergestellt werden.',
          //style the text gray
          style: TextStyle(color: Color.fromARGB(133, 36, 36, 36)),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Abbrechen'),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () async {
                    await onDelete();
                    Navigator.pop(context, true);
                  },
                  //style the button red
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Löschen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
