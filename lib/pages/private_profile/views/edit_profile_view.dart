import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/pages/inset_post/new_post/views/new_post_view.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/tags_element.dart';
import 'package:nochba/pages/private_profile/views/edit_profile_controller.dart';
import 'package:nochba/shared/ui/buttons/text_field_remove_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card_title.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/edit_avatar_copy.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:nochba/shared/views/bottom_sheet_close_save_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';

import 'widgets/tag_input_field.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: AppLocalizations.of(context)!.editProfile,
      onPressed: () => {Get.back()},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        // SizedBox(
        //   height: 30,
        // ),
        // EditAvatar(),
        // Text('data'),
        StreamBuilder<User?>(
          stream: controller.getCurrentUser(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return EditAvatar(
                  imageUrl: user.imageUrl ?? '',
                  onTap: () =>
                      controller.selectImage(context, user.imageUrl != null));
            } else {
              return Container();
            }
          }),
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
        const SizedBox(
          height: 30,
        ),
        ActionCardTitle(title: AppLocalizations.of(context)!.personalData),

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
              List<String>? interestsList = userPublicInfo.interests;
              List<String>? offersList = userPublicInfo.offers;
              if (userPublicInfo.birthday != null) {
                birthday = userPublicInfo.birthday!.toDate();
              }
              if (userPublicInfo.neighbourhoodMemberSince != null) {
                neighbourhoodMemberSince =
                    userPublicInfo.neighbourhoodMemberSince!.toDate();
              }
              controller.initializeInterests(interestsList);
              controller.initializeOffer(offersList);
              return Column(
                //align left
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  BirthdayCard(controller: controller, birthday: birthday),
                  InTheNeighborhoodSinceCard(
                      controller: controller,
                      neighbourhoodMemberSince: neighbourhoodMemberSince),
                  ActionTextCard(
                    title: AppLocalizations.of(context)!.profession,
                    icon: const Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () async => await controller
                                .updateProfessionOfCurrentUser(),
                            children: [
                              LocooTextField(
                                label: AppLocalizations.of(context)!.profession,
                                suffixIcon: TextFieldRemoveTextButton(
                                  onPressed: () => controller
                                      .professionTextController
                                      .clear(),
                                ),
                                autofocus: true,
                                controller:
                                    controller.getProfessionTextController(
                                        userPublicInfo.profession),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    },
                    text: userPublicInfo.profession ?? '',
                  ),
                  ActionTextCard(
                    title: AppLocalizations.of(context)!.moreAboutYou,
                    icon: const Icon(FlutterRemix.user_line),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return BottomSheetCloseSaveView(
                            onSave: () async =>
                                controller.updateBioOfCurrentUser(),
                            children: [
                              LocooTextField(
                                height: //size of media query
                                    MediaQuery.of(context).size.height * 0.3,
                                label:
                                    AppLocalizations.of(context)!.moreAboutYou,
                                controller: controller
                                    .getBioTextController(userPublicInfo.bio),
                                maxLines: 10,
                                autofocus: true,
                                keyboardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    },
                    text: userPublicInfo.bio ?? '',
                  ),
                  ActionCardTitle(title: AppLocalizations.of(context)!.more),
                  InterestsCard(
                      controller: controller, userPublicInfo: userPublicInfo),
                  OfferCard(
                      controller: controller, userPublicInfo: userPublicInfo),
                  // ActionCardTitle(title: 'Familie'),
                  // ActionTextCard(
                  //   title: 'Familien Status',
                  //   icon: Icon(FlutterRemix.user_line),
                  //   onTap: () {},
                  //   text: userPublicInfo.familyStatus != null
                  //       ? userPublicInfo.familyStatus!
                  //       : '',
                  // ),
                  // ActionTextCard(
                  //   title: 'Kinder',
                  //   icon: Icon(FlutterRemix.user_line),
                  //   onTap: () {
                  //     showModalBottomSheet<void>(
                  //       backgroundColor:
                  //           Theme.of(context).scaffoldBackgroundColor,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.vertical(
                  //               top: Radius.circular(25.0))),
                  //       context: context,
                  //       isScrollControlled: true,
                  //       builder: (BuildContext context) {
                  //         return BottomSheetCloseSaveView(
                  //           onSave: () {},
                  //           children: [
                  //             // ad a counter with + an- buttons
                  //             Row(
                  //               children: [
                  //                 Text('0'),
                  //                 IconButton(
                  //                   onPressed: () {},
                  //                   icon: Icon(FlutterRemix.add_line),
                  //                 ),
                  //                 IconButton(
                  //                   onPressed: () {},
                  //                   icon: Icon(FlutterRemix.subtract_line),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  //   text: '3',
                  // ),
                  // ActionTextCard(
                  //   title: 'Tiere',
                  //   icon: Icon(FlutterRemix.user_line),
                  //   onTap: () {

                  //   },
                  //   text: 'Hund, Katze',
                  // ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class OfferCard extends StatelessWidget {
  OfferCard({
    super.key,
    required this.controller,
    required this.userPublicInfo,
  });

  final EditProfileController controller;
  final UserPublicInfo userPublicInfo;
  late List<String> fixedTags = [
    'Einkaufen',
    'Gartenarbeit',
    'Kochen',
    'Computerhilfe',
    'Hundesitting',
    'Nachhilfe',
    'Handwerken',
    'Fahrgemeinschaft',
    'Babysitting',
    'Pakete annehmen',
    'Fahrrad reparieren',
    'Gesellschaft leisten',
    'Bewerbungshilfe',
    'Foodsharing',
    'Blumen gießen',
    'Katzensitting',
    'Haushaltshilfe',
    'Putzhilfe',
    'Coaching',
    'Malerarbeiten',
    'Backen',
    'Gitarrenunterricht',
  ];

  @override
  Widget build(BuildContext context) {
    return ActionTextCard(
      title: AppLocalizations.of(context)!.offers,
      icon: const Icon(FlutterRemix.user_line),
      onTap: () {
        showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return BottomSheetCloseSaveView(
              padding: // top left right 15
                  const EdgeInsets.only(top: 15, left: 11, right: 10),
              onSave: () async => await controller.updateOffersOfCurrentUser(),
              children: [
                Column(
                  children: [
                    GetBuilder<EditProfileController>(
                        id: 'EditProfileOfferTags',
                        builder: (c) => TagInputField(
                              fixedTags: fixedTags,
                              tags: controller.getOffers(),
                              removeTag: controller.removeOffer,
                              showTagDialog: controller.showOfferTagDialog,
                              addTag: controller.addOffer,
                              addText: 'Weiters Hinzufügen',
                            )),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
        controller.initializeOffer(userPublicInfo.offers);
      },
      text: userPublicInfo.offers != null && userPublicInfo.offers!.isNotEmpty
          ? userPublicInfo.offers!.fold<String>(
              '',
              (previousValue, element) =>
                  previousValue.isEmpty ? element : '$previousValue, $element')
          : '',
    );
  }
}

class InTheNeighborhoodSinceCard extends StatelessWidget {
  const InTheNeighborhoodSinceCard({
    super.key,
    required this.controller,
    required this.neighbourhoodMemberSince,
  });

  final EditProfileController controller;
  final DateTime? neighbourhoodMemberSince;

  @override
  Widget build(BuildContext context) {
    return ActionTextCard(
      title: AppLocalizations.of(context)!.inTheNeighborhoodSince,
      icon: const Icon(FlutterRemix.user_line),
      onTap: () {
        showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return BottomSheetCloseSaveView(
              onSave: () async => await controller
                  .updateNeighbourhoodMemberSinceOfCurrentUser(),
              children: [
                SfDateRangePicker(
                  controller:
                      controller.getNeighbourhoodMemberSinceDateController(
                          neighbourhoodMemberSince),
                  view: DateRangePickerView.decade,
                  // monthViewSettings:
                  //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  showNavigationArrow: true,
                  // showActionButtons: true,
                  maxDate: DateTime.now(),
                  minDate: DateTime(1880),
                  //set initial year to 1999
                  // enableMultiView: true,
                  // when onSubmit () => Navigator.pop(context),
                  // onSubmit: (value) {
                  //   Navigator.pop(context);
                  // },

                  yearCellStyle: DateRangePickerYearCellStyle(
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                    leadingDatesTextStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          ? '${neighbourhoodMemberSince?.day}.${neighbourhoodMemberSince?.month}.${neighbourhoodMemberSince?.year}'
          : '',
    );
  }
}

class InterestsCard extends StatelessWidget {
  InterestsCard({
    super.key,
    required this.controller,
    required this.userPublicInfo,
  });

  final EditProfileController controller;
  final UserPublicInfo userPublicInfo;
  List<String> hobbies = [
    'Musik',
    'Literatur',
    'Design',
    'Theater',
    'Malerei',
    'Essen & Trinken',
    'Kino',
    'Konzerte',
    'Joggen',
    'Yoga',
    'Instrument spielen',
    'Fußball',
    'Shopping',
    'Fitness',
    'Computerspiele',
    'Karten spielen',
    'Ausgehen',
    'Wandern',
    'Radfahren',
    'Tischtennis',
    'Spazieren gehen',
    'Brettspiele',
    'Kickern',
    'Spieleabend',
  ];

  @override
  Widget build(BuildContext context) {
    return ActionTextCard(
      title: AppLocalizations.of(context)!.interests,
      icon: const Icon(FlutterRemix.user_line),
      onTap: () {
        showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return BottomSheetCloseSaveView(
              onSave: () async =>
                  await controller.updateInterestsOfCurrentUser(),
              children: [
                Column(
                  children: [
                    GetBuilder<EditProfileController>(
                      id: 'EditProfileInterestTags',
                      builder: (c) => TagInputField(
                        fixedTags: hobbies,
                        tags: controller.getInterests(),
                        removeTag: controller.removeInterest,
                        showTagDialog: controller.showTagDialog,
                        addTag: controller.addInterest,
                        addText: 'Interesse Hinzufügen',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
        controller.initializeInterests(userPublicInfo.interests);
      },
      text: userPublicInfo.interests != null &&
              userPublicInfo.interests!.isNotEmpty
          ? userPublicInfo.interests!.fold<String>(
              '',
              (previousValue, element) =>
                  previousValue.isEmpty ? element : '$previousValue, $element')
          : '',
    );
  }
}

class BirthdayCard extends StatelessWidget {
  const BirthdayCard({
    super.key,
    required this.controller,
    required this.birthday,
  });

  final EditProfileController controller;
  final DateTime? birthday;

  @override
  Widget build(BuildContext context) {
    return ActionTextCard(
      title: AppLocalizations.of(context)!.birthday,
      icon: const Icon(FlutterRemix.user_line),
      onTap: () {
        showModalBottomSheet<void>(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return BottomSheetCloseSaveView(
              onSave: () async =>
                  await controller.updateBirthDayOfCurrentUser(),
              children: [
                Column(
                  children: [
                    SfDateRangePicker(
                      controller:
                          controller.getBirthdayDateController(birthday),
                      view: DateRangePickerView.decade,
                      // monthViewSettings:
                      //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                      showNavigationArrow: true,
                      // showActionButtons: true,
                      maxDate: DateTime.now(),
                      minDate: DateTime(1880),
                      //set initial year to 1999
                      // enableMultiView: true,
                      // when onSubmit () => Navigator.pop(context),
                      // onSubmit: (value) {
                      //   Navigator.pop(context);
                      // },

                      yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                ),
                        leadingDatesTextStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          const EdgeInsets.only(
                        left: 7,
                        right: 7,
                      ),
                      child: Row(
                        //spacebetween
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .displayOnlyFirstLetter,
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
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            );
          },
        );
      },
      text: birthday != null
          ? '${birthday?.day}.${birthday?.month}.${birthday?.year}'
          : '',
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
    return StreamBuilder<UserPrivateInfoName?>(
      stream: controller.getCurrentUserName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;

          return ActionTextCard(
            title: AppLocalizations.of(context)!.name,
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
                        await controller.updateNameOfCurrentUser(),
                    children: [
                      LocooTextField(
                        label: AppLocalizations.of(context)!.firstName,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        controller: controller
                            .getFirstNameTextController(user.firstName),
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
                      const SizedBox(height: 10),
                      LocooTextField(
                        label: AppLocalizations.of(context)!.lastname,
                        textInputAction: TextInputAction.done,
                        controller:
                            controller.getLastNameTextController(user.lastName),
                        suffixIcon: TextFieldRemoveTextButton(
                          onPressed: () =>
                              controller.firstNameTextController.clear(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: // right left 5
                            const EdgeInsets.only(
                          left: 7,
                          right: 7,
                        ),
                        child: Row(
                          //spacebetween
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .displayOnlyFirstLetter,
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
                            StreamBuilder<bool?>(
                              stream:
                                  controller.getCurrentUserSettingForLastName(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data!;
                                  return Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: data,
                                        onChanged: (value) async => await controller
                                            .updateSettingForLastNameOfCurrentUser(
                                                value)),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                },
              );
            },
            text: '${user.firstName} ${user.lastName}',
          );
        } else {
          return Container();
        }
      },
    );
  }
}
