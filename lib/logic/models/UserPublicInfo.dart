import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

class UserPublicInfo extends IModel {
  @override
  String id;
  //String user;
  Timestamp? birthday;
  Timestamp? neighbourhoodMemberSince;
  String? profession;
  String? originallyFrom;
  String? familyStatus;
  bool? hasChildren;
  bool? hasPets;
  List<String>? interests;
  List<String>? offers;
  String? bio;

  UserPublicInfo(
      {this.id = '',
      //required this.user,
      this.birthday,
      this.neighbourhoodMemberSince,
      this.profession,
      this.originallyFrom,
      this.familyStatus,
      this.hasChildren,
      this.hasPets,
      this.interests,
      this.offers,
      this.bio});

  @override
  Map<String, dynamic> toJson() => {
        'birthday': birthday,
        'neighbourhoodMemberSince': neighbourhoodMemberSince,
        'profession': profession,
        'originallyFrom': originallyFrom,
        'familyStatus': familyStatus,
        'hasChildren': hasChildren,
        'hasPets': hasPets,
        'interests': interests,
        'offers': offers,
        'bio': bio,
      };

  factory UserPublicInfo.fromJson(String id, Map<String, dynamic> json) =>
      UserPublicInfo(
        id: id,
        birthday: json['birthday'],
        neighbourhoodMemberSince: json['neighbourhoodMemberSince'],
        profession: json['profession'],
        originallyFrom: json['originallyFrom'],
        familyStatus: json['familyStatus'],
        hasChildren: json['hasChildren'],
        hasPets: json['hasPets'],
        interests: json['interests'] != null
            ? List.castFrom<dynamic, String>(json['interests'])
            : null,
        offers: json['offers'] != null
            ? List.castFrom<dynamic, String>(json['offers'])
            : null,
        bio: json['bio'],
      );
}
