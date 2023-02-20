import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/private_profile/views/settings/manage_account_controller.dart';
import 'package:nochba/shared/ui/cards/action_text_card.dart';
import 'package:nochba/shared/ui/cards/action_text_card_red.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

enum Language { German, English }

class LanguageSelectorView extends GetView<ManageAccountController> {
  const LanguageSelectorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: 'Sprache',
      onPressed: () => {Get.back()},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        RadioLangSelector(),
      ],
    );
  }
}

class RadioLangSelector extends StatefulWidget {
  const RadioLangSelector({
    super.key,
  });

  @override
  State<RadioLangSelector> createState() => _RadioLangSelectorState();
}

class _RadioLangSelectorState extends State<RadioLangSelector> {
  Language? _character = Language.German;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => setState(() {
            _character = Language.German;
          }),
          tileColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          shape: // radius 14
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            'Deutsch',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  // letterSpacing: -0.1,
                ),
          ),
          trailing: Radio<Language>(
            activeColor: Theme.of(context).primaryColor,
            value: Language.German,
            groupValue: _character,
            onChanged: (Language? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        SizedBox(height: 7),
        ListTile(
          onTap: () => setState(() {
            _character = Language.English;
          }),

          // add a  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          // borderRadius: BorderRadius.circular(14),
          tileColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          shape: // radius 14
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          title: Text(
            'Englisch',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  // letterSpacing: -0.1,
                ),
          ),
          trailing: Radio<Language>(
            activeColor: Theme.of(context).primaryColor,
            value: Language.English,
            groupValue: _character,
            onChanged: (Language? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
