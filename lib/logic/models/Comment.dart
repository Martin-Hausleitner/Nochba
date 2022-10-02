import 'package:nochba/logic/interfaces/IModel.dart';

class Comment implements IModel {
  @override
  String id;

  Comment({
    this.id = '',
  });

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
      );
}
