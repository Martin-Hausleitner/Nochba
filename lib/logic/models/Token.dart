import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

class Token implements IModel {
  @override
  String id;
  String token;
  FieldValue createdAt;

  Token({
    this.id = '',
    required this.token,
    required this.createdAt,
  });

  // Token.fromData(Map<String, dynamic> data)
  //     : token = data['token'],
  //       createdAt = data['createdAt'];

  static Token fromJson(String id, Map<String, dynamic> map) => Token(
        id: id,
        token: map['token'],
        createdAt: map['createdAt'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'token': token,
        'createdAt': createdAt,
      };
}
