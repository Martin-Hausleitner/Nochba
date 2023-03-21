import 'dart:ui';

import 'package:nochba/logic/models/user.dart';

//lib\logic\flutter_chat_types-3.4.5\src\user.dart

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(User user) => (user.fullName ?? '').trim();
