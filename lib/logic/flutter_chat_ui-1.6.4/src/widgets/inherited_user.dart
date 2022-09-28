import 'package:flutter/widgets.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:locoo/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart' as types;
import 'package:locoo/logic/models/user.dart' as models;

/// Used to make provided [types.User] class available through the whole package.
class InheritedUser extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [types.User] class.
  const InheritedUser({
    super.key,
    required this.user,
    required super.child,
  });

  /// Represents current logged in user. Used to determine message's author.
  final models.User user;

  static InheritedUser of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedUser>()!;

  @override
  bool updateShouldNotify(InheritedUser oldWidget) =>
      user.id != oldWidget.user.id;
}
