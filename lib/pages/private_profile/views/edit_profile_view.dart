import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/shared/ui/buttons/locoo_circular_icon_button.dart';
import 'package:locoo/shared/ui/cards/action_card_title.dart';
import 'package:locoo/shared/ui/cards/action_text_card.dart';
import 'package:locoo/shared/ui/locoo_text_field.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';
import 'package:locoo/shared/views/bottom_sheet_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../private_profile_page.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(title: 'Profil Bearbeiten', children: [
      // SizedBox(
      //   height: 30,
      // ),
      // EditAvatar(),
      Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            LocooCircularIconButton(
              iconData: FlutterRemix.pencil_line,
              fillColor: Theme.of(context).primaryColor,
              iconColor: Colors.white,
              radius: 32,
              onPressed: () => Navigator.pop(context),
            ),
            CircleAvatar(
              backgroundColor: Colors.black26,
              radius: 55,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
              ),
            ),
            LocooCircularIconButton(
              iconData: FlutterRemix.pencil_line,
              fillColor: Theme.of(context).primaryColor,
              iconColor: Colors.white,
              radius: 32,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
      ActionCardTitle(title: 'Persönliche Daten'),
      ActionTextCard(
        title: 'Name',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheetView(
                children: [
                  LocooTextField(
                    label: 'Vorname',
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    controller: TextEditingController(text: 'Max'),
                  ),
                  SizedBox(height: 10),
                  LocooTextField(
                    label: 'Nachname',
                    textInputAction: TextInputAction.done,
                    controller: TextEditingController(text: 'Mustermann'),
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
        text: 'Martin Hausleitner',
      ),
      ActionTextCard(
        title: 'Geburtstag',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheetView(
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
        text: '01.01.2022',
      ),
      ActionTextCard(
        title: 'In der Nachbarschaft seit',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheetView(
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
                ],
              );
            },
          );
        },
        text: '01.01.2022',
      ),
      ActionTextCard(
        title: 'Beruf',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheetView(
                children: [
                  LocooTextField(
                    label: 'Beruf',
                    autofocus: true,
                    controller: TextEditingController(text: 'Beruf'),
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
        text: 'Legobaumeister',
      ),

      ActionTextCard(
        title: 'Mehr über dich',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheetView(
                children: [
                  LocooTextField(
                    label: 'Mehr über dich',
                    controller: TextEditingController(text: 'Mehr über dich'),
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
        text: 'Hallo, mein name ist martin und ich bin ein legobaumeister',
      ),
      ActionCardTitle(title: 'Mehr'),
      ActionTextCard(
        title: 'Interessen',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Freunde, Familie, Legobaumeister',
      ),
      ActionTextCard(
        title: 'Bietet',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Babysitten, Nachb',
      ),
      ActionCardTitle(title: 'Familie'),
      ActionTextCard(
        title: 'Familien Status',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {},
        text: 'Verheiratet',
      ),
      ActionTextCard(
        title: 'Kinder',
        icon: Icon(FlutterRemix.user_line),
        onTap: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return BottomSheetView(
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
      SizedBox(
        height: 40,
      ),
    ]);
  }
}
