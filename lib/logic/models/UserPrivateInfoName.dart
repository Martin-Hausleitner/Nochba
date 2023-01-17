import 'package:nochba/logic/interfaces/IModel.dart';

class UserPrivateInfoName implements IModel {
  @override
  String id;
  final String firstName;
  final String lastName;

  UserPrivateInfoName(
      {this.id = '', required this.firstName, required this.lastName});

  @override
  Map<String, dynamic> toJson() =>
      {'firstName': firstName, 'lastName': lastName};

  static UserPrivateInfoName fromJson(String id, Map<String, dynamic> json) =>
      UserPrivateInfoName(
          id: id, firstName: json['firstName'], lastName: json['lastName']);
}
