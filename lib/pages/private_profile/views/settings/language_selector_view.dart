import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/private_profile/views/settings/manage_account_controller.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';

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
      ],
    );
  }
}

String getLanguageName(String languageCode) {
  switch (languageCode) {
    case 'de':
      return 'German';
    case 'en':
      return 'English';
    case 'uk':
      return 'Ukrainian';
    case 'es':
      return 'Spanish';
    default:
      return '';
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return Column(
      children: L10n.all.map((locale) {
        final flag = L10n.getFlag(locale.languageCode);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            onTap: () {
              final localeProvider =
                  Provider.of<LocaleProvider>(context, listen: false);
              localeProvider.setLocale(locale);
            },
            tileColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: Row(
              children: [
                Text(
                  flag,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 8),
                Text(
                  getLanguageName(locale.languageCode),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            trailing: Radio<Locale>(
              activeColor: Theme.of(context).primaryColor,
              value: locale,
              groupValue: provider.locale,
              onChanged: (Locale? value) {
                final localeProvider =
                    Provider.of<LocaleProvider>(context, listen: false);
                localeProvider.setLocale(value!);
              },
            ),
          ),
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
