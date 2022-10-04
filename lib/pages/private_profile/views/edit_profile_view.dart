import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/flutter_firebase_chat_core-1.6.3/flutter_firebase_chat_core.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/pages/private_profile/views/edit_profile_controller.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:nochba/shared/ui/buttons/text_field_remove_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card_title.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/edit_avatar.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:nochba/shared/views/bottom_sheet_close_save_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../private_profile_page.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Profil Bearbeiten',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        // SizedBox(
        //   height: 30,
        // ),
        // EditAvatar(),
        // Text('data'),
        EditAvatar(
          imageUrl:
              'https://play-lh.googleusercontent.com/03URhAXU-IrK5PB-DiN6lyLGITlp-6xTizXkW5l98AUvpzOxQej6ss_zM4f8zxN0ofEf',
          onTap: () => Get.snackbar('title', 'message'),
        ),
        // Center(
        //   child: Stack(
        //     alignment: Alignment.bottomRight,
        //     children: [
        //       CircleAvatar(
        //         backgroundColor: Colors.black26,
        //         radius: 55,
        //         backgroundImage: NetworkImage(
        //           "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
        //         ),
        //       ),
        //       LocooCircularIconButton(
        //         iconData: FlutterRemix.pencil_line,
        //         fillColor: Theme.of(context).primaryColor,
        //         iconColor: Colors.white,
        //         radius: 32,
        //         onPressed: () => Navigator.pop(context),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          height: 30,
        ),
        ActionCardTitle(title: 'Persönliche Daten'),

        NameElement(
          controller: controller,
        ),
        StreamBuilder<UserPublicInfo?>(
          stream: controller.getPublicInfoOfCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error!.toString());
            } else if (snapshot.hasData) {
              final userPublicInfo = snapshot.data!;
              DateTime? birthday;
              DateTime? neighbourhoodMemberSince;
              if (userPublicInfo.birthday != null) {
                birthday = userPublicInfo.birthday!.toDate();
              }
              if (userPublicInfo.neighbourhoodMemberSince != null) {
                neighbourhoodMemberSince =
                    userPublicInfo.neighbourhoodMemberSince!.toDate();
              }
              return Column(
                //align left
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ActionTextCard(
                    title: 'Geburtstag',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () {},
                            children: [
                              Column(
                                children: [
                                  SfDateRangePicker(
                                    view: DateRangePickerView.decade,
                                    // monthViewSettings:
                                    //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                                    showNavigationArrow: true,
                                    // showActionButtons: true,
                                    maxDate: DateTime.now(),
                                    minDate: DateTime(1880),
                                    //set initial year to 1999
                                    // enableMultiView: true,
                                    initialDisplayDate: DateTime(2000),
                                    // when onSubmit () => Navigator.pop(context),
                                    // onSubmit: (value) {
                                    //   Navigator.pop(context);
                                    // },

                                    yearCellStyle: DateRangePickerYearCellStyle(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(0.7),
                                          ),
                                      leadingDatesTextStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(0.7),
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: // right left 5
                                        EdgeInsets.only(
                                      left: 7,
                                      right: 7,
                                    ),
                                    child: Row(
                                      //spacebetween
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,

                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Zeiger nur den ersten Buchstaben deines Nachnahmen an',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color
                                                        ?.withOpacity(0.6)),
                                          ),
                                        ),

                                        //tranform  scale 0.8 cupertuon swtich
                                        Transform.scale(
                                          scale: 0.8,
                                          child: CupertinoSwitch(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: true,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: birthday != null
                        ? '${birthday.day}.${birthday.month}.${birthday.year}'
                        : '',
                  ),
                  ActionTextCard(
                    title: 'In der Nachbarschaft seit',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () {},
                            children: [
                              SfDateRangePicker(
                                controller: controller.birthdayDateController,
                                view: DateRangePickerView.decade,
                                // monthViewSettings:
                                //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                                showNavigationArrow: true,
                                // showActionButtons: true,
                                maxDate: DateTime.now(),
                                minDate: DateTime(1880),
                                //set initial year to 1999
                                // enableMultiView: true,
                                initialDisplayDate: DateTime(2000),
                                // when onSubmit () => Navigator.pop(context),
                                // onSubmit: (value) {
                                //   Navigator.pop(context);
                                // },

                                yearCellStyle: DateRangePickerYearCellStyle(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                  leadingDatesTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: neighbourhoodMemberSince != null
                        ? '${neighbourhoodMemberSince.day}.${neighbourhoodMemberSince.month}.${neighbourhoodMemberSince.year}'
                        : '',
                  ),
                  ActionTextCard(
                    title: 'Beruf',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () {},
                            children: [
                              LocooTextField(
                                label: 'Beruf',
                                autofocus: true,
                                controller: controller.jobTitleTextController,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: userPublicInfo.profession != null
                        ? userPublicInfo.profession!
                        : '',
                  ),
                  ActionTextCard(
                    title: 'Mehr über dich',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () {},
                            children: [
                              LocooTextField(
                                label: 'Mehr über dich',
                                controller: TextEditingController(
                                    text: 'Mehr über dich'),
                                maxLines: 10,
                                autofocus: true,
                                keyboardType: TextInputType.multiline,
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: userPublicInfo.bio != null
                        ? userPublicInfo.bio!
                        : '',
                  ),
                  ActionCardTitle(title: 'Mehr'),
                  ActionTextCard(
                    title: 'Interessen',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {},
                    text: userPublicInfo.interests != null &&
                            userPublicInfo.interests!.isNotEmpty
                        ? userPublicInfo.interests!.fold<String>(
                            userPublicInfo.interests!.first,
                            (previousValue, element) =>
                                '$previousValue, $element')
                        : '',
                  ),
                  ActionTextCard(
                    title: 'Bietet',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {},
                    text: userPublicInfo.offers != null &&
                            userPublicInfo.offers!.isNotEmpty
                        ? userPublicInfo.offers!.fold<String>(
                            userPublicInfo.offers!.first,
                            (previousValue, element) =>
                                '$previousValue, $element')
                        : '',
                  ),
                  ActionCardTitle(title: 'Familie'),
                  ActionTextCard(
                    title: 'Familien Status',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {},
                    text: userPublicInfo.familyStatus != null
                        ? userPublicInfo.familyStatus!
                        : '',
                  ),
                  ActionTextCard(
                    title: 'Kinder',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () {},
                            children: [
                              // ad a counter with + an- buttons
                              Row(
                                children: [
                                  Text('0'),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(FlutterRemix.add_line),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(FlutterRemix.subtract_line),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: '3',
                  ),
                  ActionTextCard(
                    title: 'Tiere',
                    icon: Icon(FlutterRemix.user_line),
                    onTap: () {},
                    text: 'Hund, Katze',
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class NameElement extends StatelessWidget {
  const NameElement({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: controller.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return ActionTextCard(
            title: 'Name',
            icon: Icon(FlutterRemix.user_line),
            onTap: () {
              showModalBottomSheet<void>(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return BottomSheetCloseSaveView(
                    onSave: () async =>
                        await controller.updateNameOfCurrentUser(),
                    children: [
                      LocooTextField(
                        label: 'Vorname',
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        controller: controller.firstNameTextController,
                        // suffixIcon: IconButton(
                        //   // onPressed: _controller.clear,
                        //   iconSize: ,
                        //   onPressed: () =>
                        //       controller.firstNameTextController.clear(),
                        //   icon: Icon(Icons.clear),
                        // ),
                        suffixIcon: TextFieldRemoveTextButton(
                          onPressed: () =>
                              controller.firstNameTextController.clear(),
                        ),
                      ),
                      SizedBox(height: 10),
                      LocooTextField(
                        label: 'Nachname',
                        textInputAction: TextInputAction.done,
                        controller: controller.lastNameTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: // right left 5
                            EdgeInsets.only(
                          left: 7,
                          right: 7,
                        ),
                        child: Row(
                          //spacebetween
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Flexible(
                              child: Text(
                                'Zeiger nur den ersten Buchstaben deines Nachnahmen an',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.6)),
                              ),
                            ),

                            //tranform  scale 0.8 cupertuon swtich
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                activeColor: Theme.of(context).primaryColor,
                                value: true,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                },
              );
            },
            text: '${user?.firstName} ${user?.lastName}',
          );
        } else {
          return Container();
        }
      },
    );
  }
}
