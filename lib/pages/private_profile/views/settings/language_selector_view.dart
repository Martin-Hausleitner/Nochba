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

enum Language { German, English }

class LanguageSelectorView extends GetView<ManageAccountController> {
  const LanguageSelectorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      title: AppLocalizations.of(context)!.languages,
      onPressed: () => {Get.back()},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        LanguagePickerWidget(),
        LanguagePickerWidgetRadio(),
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
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 72,
          backgroundColor: Colors.white,
          child: Text(flag, style: TextStyle(fontSize: 50)),
        ),
        Text(
          AppLocalizations.of(context)!.language,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                // letterSpacing: -0.1,
              ),
        ),
        SizedBox(height: 7),
        Text(
          AppLocalizations.of(context)!.helloWorld,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
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
            AppLocalizations.of(context)!.german,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  // letterSpacing: -0.1,
                ),
          ),
          trailing: Radio<Locale>(
            activeColor: Theme.of(context).primaryColor,
            value: Locale.fromSubtags(languageCode: 'de'),
            groupValue: locale,
            onChanged: (Locale? value) {
              setState(() {
                final localeProvider = Provider.of<LocaleProvider>(context);
                localeProvider.setLocale(value!);
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
            AppLocalizations.of(context)!.english,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  // letterSpacing: -0.1,
                ),
          ),
          trailing: Radio<Language>(
            activeColor: Theme.of(context).primaryColor,
            value: Language.English,
            groupValue: _character,
            onChanged: (Language? value) {},
          ),
        ),
      ],
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return DropdownButtonHideUnderline(
        child: DropdownButton(
      value: locale,
      icon: Container(width: 12),
      items: L10n.all.map(
        (locale) {
          final flag = L10n.getFlag(locale.languageCode);

          return DropdownMenuItem(
            child: Center(
              child: Text(
                flag,
                style: TextStyle(fontSize: 50),
              ),
            ),
            value: locale,
            onTap: () {
              final provider =
                  Provider.of<LocaleProvider>(context, listen: false);
              provider.setLocale(locale);
            },
          );
        },
      ).toList(),
      onChanged: (_) {},
    ));
  }
}

class LanguagePickerWidgetRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return Column(
      children: L10n.all.map((locale) {
        final flag = L10n.getFlag(locale.languageCode);

        return RadioListTile(
          title: Text(flag),
          value: locale,
          groupValue: provider.locale,
          onChanged: (selectedLocale) {
            final provider =
                Provider.of<LocaleProvider>(context, listen: false);
            provider.setLocale(locale);
          },
        );
      }).toList(),
    );
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
