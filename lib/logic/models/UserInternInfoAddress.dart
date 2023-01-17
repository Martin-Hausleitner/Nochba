import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

class UserInternInfoAddress implements IModel {
  @override
  String id;
  final GeoFirePoint position;

  UserInternInfoAddress({this.id = '', required this.position});

  @override
  Map<String, dynamic> toJson() => {'position': position.data};

  static UserInternInfoAddress fromJson(String id, Map<String, dynamic> json) =>
      UserInternInfoAddress(
        id: id,
        position: GeoFirePoint(
            json['position']['geopoint'][0], json['position']['geopoint'][1]),
      );
}
