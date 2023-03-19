//import material

import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:nochba/logic/commonbase/util.dart';
import 'package:nochba/logic/models/category.dart';
import 'package:nochba/logic/models/post.dart' as models;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nochba/pages/feed/views/post_view.dart';
import 'package:nochba/pages/feed/widgets/post/action_bar.dart';
import 'package:nochba/pages/feed/widgets/post/post_profile.dart';
import 'package:nochba/pages/feed/widgets/post_card_controller.dart';
// import 'package:simplytranslate/simplytranslate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nochba/pages/private_profile/views/settings/manage_account_controller.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:nochba/l10n/l10n.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';

import 'post/category_badge.dart';
import 'post/discription.dart';
import 'post/hashtag_badges.dart';

class Post extends StatefulWidget {
  final models.Post post;
  CategoryOptions category = CategoryOptions.None;
  final controller = PostCardController();

  String titleTranslation = '';
  String descriptionTranslation = '';

  Post({Key? key, required this.post}) : super(key: key) {
    category = CategoryModul.getCategoryOptionByName(post.category);
  }

  final _PostState postState = _PostState();

  @override
  _PostState createState() => _PostState();
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

class _PostState extends State<Post> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> startTranslation() async {
    await translatePost();
  }

  // Utility function to convert language code to TranslateLanguage
  TranslateLanguage? languageCodeToTranslateLanguage(String languageCode) {
    try {
      return TranslateLanguage.values
          .firstWhere((element) => element.bcpCode == languageCode);
    } catch (_) {
      return null;
    }
  }

  Future<void> translatePost() async {
  try {
    final sourceLanguage = TranslateLanguage.german;
    final targetLanguage = TranslateLanguage.english;
    final _modelManager = OnDeviceTranslatorModelManager();

    await downloadLanguageModel(sourceLanguage);
    await downloadLanguageModel(targetLanguage);

    print(
        'Model downloaded: ${await _modelManager.isModelDownloaded(sourceLanguage.bcpCode)}');
    print(
        'Model downloaded: ${await _modelManager.isModelDownloaded(targetLanguage.bcpCode)}');

    final OnDeviceTranslator onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    final String titleTranslation =
        await onDeviceTranslator.translateText(widget.post.title);
    final String descriptionTranslation =
        await onDeviceTranslator.translateText(widget.post.description);

    setState(() {
      widget.titleTranslation = titleTranslation;
      widget.descriptionTranslation = descriptionTranslation;
    });
  } catch (e) {
    print('Error translating text: $e');
    Get.snackbar(
      'Error',
      'Could not translate text. Please try again later. $e',
    );
  }
}

  Future<void> downloadLanguageModel(TranslateLanguage language) async {
    try {
      final modelManager = OnDeviceTranslatorModelManager();
      final modelDownloaded =
          await modelManager.isModelDownloaded(language.bcpCode);

      if (!modelDownloaded) {
        await modelManager.downloadModel(language.bcpCode).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Model download timed out');
          },
        );
      }
    } catch (e) {
      throw Exception('Error downloading model for ${language.bcpCode}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBetween = 13;

    return GestureDetector(
      //onTap open postz view
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostView(post: widget.post),
          ),
        );
      },
      onLongPress: () async {
        await translatePost();
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        //create two text children
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            //allign left
            children: <Widget>[
              // Post title
              Row(
                children: [
                  //show only if categor is event
                  if (widget.category == CategoryOptions.Event)
                    DateDisplay(
                      date: widget.post.eventBeginTime != null
                          ? widget.post.eventBeginTime!.toDate()
                          : DateTime.now(),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            widget.titleTranslation.isNotEmpty
                                ? widget.titleTranslation
                                : widget.post.title,
                            //chnage the space between the words
                            // textAlign: TextAlign.top,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                )),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: spacingBetween),

              // Badges
              Row(
                // horizontal start
                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Category Badge
                  CategoryBadge(
                    category: widget.category,
                  ),

                  // Hashtag Badges
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HashtagBadges(hashtags: widget.post.tags),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: spacingBetween),

              FutureBuilder<String>(
                future: widget.controller.getDistanceToUser(widget.post.id),
                builder: (context, snapshot) {
                  String distance = '---';
                  if (snapshot.hasData) {
                    distance = snapshot.data!;
                  }

                  return PostProfile(
                      post: widget.post,
                      publishDate: getTimeAgo(widget.post.createdAt.toDate()),
                      distance: distance);
                },
              ),

              const SizedBox(height: spacingBetween),
              if (widget.category == CategoryOptions.Event)
                EventInfo(
                  startDate: widget.post.eventBeginTime != null
                      ? widget.post.eventBeginTime!.toDate()
                      : DateTime.now(),
                  endDate: widget.post.eventEndTime != null
                      ? widget.post.eventEndTime!.toDate()
                      : DateTime.now().add(
                          Duration(
                            // days: 1,
                            hours: 23,
                            minutes: 59,
                            seconds: 59,
                          ),
                        ),
                  location: widget.post.eventLocation ?? '',
                ),
              const SizedBox(height: spacingBetween),

              Discription(
                postDescription: widget.descriptionTranslation.isNotEmpty
                    ? widget.descriptionTranslation
                    : widget.post.description,
              ),

              // Post Image
              widget.post.imageUrl != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: spacingBetween),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Hero(
                            tag: widget.post.id,
                            child: Image.network(
                              widget.post.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),

              // Button
              if (widget.controller
                  .shouldShowWriteToButton(widget.post.uid, widget.category))
                Padding(
                  padding: const EdgeInsets.only(top: spacingBetween),
                  child: LocooTextButton(
                    label: AppLocalizations.of(context)!.sendMessage,

                    borderRadius: 100,
                    height: 48,
                    icon: FlutterRemix.chat_1_fill, //onpres open Get.Snackbar
                    onPressed: () async => await widget.controller
                        .sendNotification(widget.post.uid, widget.post.id),
                  ),
                ),

              const SizedBox(height: spacingBetween),

              // Action Bar
              ActionBar(
                post: widget.post,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventInfo extends StatelessWidget {
  //start date and end date
  final DateTime startDate;
  final DateTime endDate;
  final String location;

  const EventInfo(
      {super.key,
      required this.startDate,
      required this.endDate,
      this.location = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FlutterRemix.calendar_line,
                    color: Colors.grey[400],
                    size: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (startDate.difference(endDate).inDays < 0) ...[
                    Text(
                        '${DateFormat('d.M.yyyy').format(startDate)} ${DateFormat('HH:mm').format(startDate)} - ${DateFormat('d.M.yyyy').format(endDate)} ${DateFormat('HH:mm').format(endDate)}'),
                  ] else ...[
                    Text(DateFormat('d. MMMM yyyy').format(startDate)),
                  ],
                ],
              ),
              if (startDate.difference(endDate).inDays == 0)
                Row(
                  children: [
                    Icon(
                      FlutterRemix.time_line,
                      color: Colors.grey[400],
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        '${DateFormat('HH:mm').format(startDate)} - ${DateFormat('HH:mm').format(endDate)}'),
                  ],
                ),
              if (location != '')
                Row(
                  children: [
                    Icon(
                      FlutterRemix.map_pin_line,
                      color: Colors.grey[400],
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(location),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class DateDisplay extends StatelessWidget {
  final DateTime date;

  const DateDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var weekStart = now.subtract(Duration(days: now.weekday - 1));
    var weekEnd = weekStart.add(const Duration(days: 7));

    String display;
    if (date.isAfter(weekStart) && date.isBefore(weekEnd)) {
      display = DateFormat('EEE').format(date);
    } else {
      display = DateFormat('MMM').format(date);
    }

    return Padding(
      padding: //left 18
          const EdgeInsets.only(right: 12),
      child: Container(
        width: 56,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: // c6c6ca
              Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                //display the month with 3 letters as a string
                display,
                style: TextStyle(
                  fontSize: 12,
                  // fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date.day.toString(),
                // "12",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // show only when the year is not the current year
              if (date.year != DateTime.now().year)
                Padding(
                  padding: //top 3
                      const EdgeInsets.only(top: 3),
                  child: Text(
                    date.year.toString(),
                    style: TextStyle(
                      // fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
