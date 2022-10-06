import 'package:get_time_ago/get_time_ago.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
//bool isType<Type1, Type2>() => Type1 == Type2;

Type typeOf<X>() => X;

String getTimeAgo(DateTime dateTime) {
  return GetTimeAgo.parse(dateTime, locale: 'de');
}

String timeAgo(DateTime dateTime) {
  return timeago.format(dateTime, locale: 'de');
}
