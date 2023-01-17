import 'package:nochba/logic/interfaces/IModel.dart';

class UserPrivateInfoSettings implements IModel {
  @override
  String id;
  final bool permReqBeforeChat;
  final bool lastNameInitialOnly;

  UserPrivateInfoSettings(
      {this.id = '',
      required this.permReqBeforeChat,
      required this.lastNameInitialOnly});

  @override
  Map<String, dynamic> toJson() => {
        'permReqBeforeChat': permReqBeforeChat,
        'lastNameInitialOnly': lastNameInitialOnly
      };

  static UserPrivateInfoSettings fromJson(
          String id, Map<String, dynamic> json) =>
      UserPrivateInfoSettings(
          id: id,
          permReqBeforeChat: json['permReqBeforeChat'],
          lastNameInitialOnly: json['lastNameInitialOnly']);
}
