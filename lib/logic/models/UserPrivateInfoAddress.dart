import 'package:nochba/logic/interfaces/IModel.dart';

class UserPrivateInfoAddress implements IModel {
  @override
  String id;
  final String street;
  final String streetNumber;
  final String city;
  final String zip;

  UserPrivateInfoAddress(
      {this.id = '',
      required this.street,
      required this.streetNumber,
      required this.city,
      required this.zip});

  @override
  Map<String, dynamic> toJson() => {
        'street': street,
        'streetNumber': streetNumber,
        'city': city,
        'zip': zip,
      };

  static UserPrivateInfoAddress fromJson(
          String id, Map<String, dynamic> json) =>
      UserPrivateInfoAddress(
          id: id,
          street: json['street'],
          streetNumber: json['streetNumber'],
          city: json['city'],
          zip: json['zip']);
}
