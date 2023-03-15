import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/feed/views/action_bar_more/action_bar_more_view.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/bottom_sheet_title_close_view.dart';
import 'package:nochba/views/public_profile/public_profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PublicProfileMoreView extends StatelessWidget {
  const PublicProfileMoreView({
    Key? key,
    required this.controller,
    required this.userId,
  }) : super(key: key);

  final PublicProfileController controller;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BottomSheetTitleCloseView(
      title: AppLocalizations.of(context)!.more,
      children: [
        Padding(
          padding: //const EdgeInsets.symmetric(horizontal: 15), top 10 left 15 right 15
              const EdgeInsets.only(top: 10, left: 15, right: 15),
             
          child: Column(
            children: [
              ActionCard(
                title: AppLocalizations.of(context)!.reportProfile,
                icon: FlutterRemix.flag_line,
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0))),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BottomSheetTitleCloseView(
                        title: AppLocalizations.of(context)!.reportProfile,
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
                                  AppLocalizations.of(context)!.selectYourReason,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                //       .copyWith(
                                //           color: Theme.of(context)
                                //               .textTheme
                                //               .bodyText1!
                                //               .color!
                                //               .withOpacity(0.8)),
                                // ),
                                const SizedBox(height: 5),

                                GetBuilder<PublicProfileController>(
                                  id: 'ReportUserDropDown',
                                  builder: (c) => DropdownButtonExample(
                                    dropDownValues: controller.reasonsForReport,
                                    selectedValue:
                                        controller.selectedReasonForReport,
                                    selectValue:
                                        controller.selectReasonForReport,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Form(
                                  key: controller.reportKey,
                                  child: Column(
                                    children: [
                                      LocooTextField(
                                          maxLines: 10,
                                          height: 220,
                                          // controller:
                                          // controller.descriptionController,
                                          // textInputAction: TextInputAction.next,
                                          label: AppLocalizations.of(context)!.description,
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          controller:
                                              controller.reportTextController,
                                          validator: (value) =>
                                              value != null && value.isEmpty
                                                  ? 'Enter a description'
                                                  : null),
                                      const SizedBox(height: 10),
                                      LocooTextButton(
                                        label: AppLocalizations.of(context)!.reportProfile,
                                        onPressed: () async => await controller
                                            .onPressReportSend(userId),
                                        icon: FlutterRemix.flag_line,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

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
              if (controller.shouldShowEditProfileButton(userId))
                ActionCard(
                  title: AppLocalizations.of(context)!.editProfile,
                  icon: FlutterRemix.pencil_line,
                  //open EditProfileView() widget
                  onTap: () => controller.pushEditProfileView(),
                ),
              // ActionCard(
              //   title: 'Post löschen',
              //   icon: FlutterRemix.delete_bin_line,
              //   onTap: () => showDialog<String>(
              //     context: context,
              //     builder: (BuildContext context) => AlertDialogDeletePost(),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(
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

 List<String> list = <String>[
  'Belästigung',
  'Unangebrachte Inhalte',
  'Spam',
  'Betrug',
  'Spamming',
  'Sonstiges'
];

// class DropdownButtonExample extends StatefulWidget {
//   const DropdownButtonExample({super.key});

//   @override
//   State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
// }

// class _DropdownButtonExampleState extends State<DropdownButtonExample> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         // border: Border.all(color: _borderColor, width: 1.5),
//         borderRadius: BorderRadius.circular(12),
//         color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
//       ),
//       child: Padding(
//         padding: // left right 5 top 5 bottom 5
//             const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
//         child: DropdownButton<String>(
//           value: dropdownValue,
//           isExpanded: true,
//           icon: const Icon(
//             Icons.expand_more_outlined,
//           ),
//           // elevation: 16,
//           style: TextStyle(
//             // color: Theme.of(context).primaryColor,
//             color: Theme.of(context).textTheme.bodyLarge!.color,
//           ),
//           underline: Container(
//             height: 0,
//             // color: Theme.of(context).primaryColor,
//           ),
//           onChanged: (String? value) {
//             // This is called when the user selects an item.
//             setState(() {
//               dropdownValue = value!;
//             });
//           },
//           items: list.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

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
                  onPressed: () => Navigator.pop(context, 'OK'),
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
