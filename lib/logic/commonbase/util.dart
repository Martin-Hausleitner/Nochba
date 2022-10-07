import 'package:get_time_ago/get_time_ago.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
//bool isType<Type1, Type2>() => Type1 == Type2;

Type typeOf<X>() => X;

String getCalenderDate(DateTime dateTime) {
  return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
}

String getTimeAgo(DateTime dateTime) {
  return GetTimeAgo.parse(dateTime, locale: 'de');
}

class DEMessage implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String suffixAgo() => '';

  @override
  String secsAgo(int seconds) => 'just now';

  @override
  String minAgo(int minutes) => '1min ago';

  @override
  String minsAgo(int minutes) => '${minutes}min ago';

  @override
  String hourAgo(int minutes) => '1h ago';

  @override
  String hoursAgo(int hours) => '${hours}h ago';

  @override
  String dayAgo(int hours) => '1d ago';

  @override
  String daysAgo(int days) => '${days}d ago';

  @override
  String wordSeparator() => ' ';
}

String timeAgo(DateTime dateTime) {
  return timeago.format(dateTime, locale: 'de');
}
