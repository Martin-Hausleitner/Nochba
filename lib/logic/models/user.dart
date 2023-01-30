import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//part 'user.g.dart';

/// All possible roles user can have.
enum Role { admin, agent, moderator, user }

/// A class that represents user.
@JsonSerializable()
@immutable
abstract class User extends Equatable implements IModel {
  /// Creates a user.
  const User._(
      {this.createdAt,
      this.firstName,
      required this.id,
      this.imageUrl,
      this.lastName,
      this.lastSeen,
      this.metadata,
      this.role,
      this.updatedAt,
      this.fullName,
      this.suburb});

  const factory User(
      {Timestamp? createdAt,
      String? firstName,
      required String id,
      String? imageUrl,
      String? lastName,
      Timestamp? lastSeen,
      Map<String, dynamic>? metadata,
      Role? role,
      Timestamp? updatedAt,
      String? fullName,
      String? suburb}) = _User;

  /// Creates user from a map (decoded JSON).
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Created user timestamp, in ms.
  final Timestamp? createdAt;

  /// First name of the user.
  final String? firstName;

  /// Unique ID of the user.
  @override
  final String id;

  /// Remote image URL representing user's avatar.
  final String? imageUrl;

  /// Last name of the user.
  final String? lastName;

  /// Timestamp when user was last visible, in ms.
  final Timestamp? lastSeen;

  /// Additional custom metadata or attributes related to the user.
  final Map<String, dynamic>? metadata;

  /// User [Role].
  final Role? role;

  /// Updated user timestamp, in ms.
  final Timestamp? updatedAt;

  ///
  /// Full name of the user.
  final String? fullName;

  ///
  /// Full name of the user.
  final String? suburb;

  /// Equatable props.
  @override
  List<Object?> get props => [
        createdAt,
        firstName,
        id,
        imageUrl,
        lastName,
        lastSeen,
        metadata,
        role,
        updatedAt,
        fullName,
        suburb
      ];

  User copyWith(
      {Timestamp? createdAt,
      String? firstName,
      String? id,
      String? imageUrl,
      String? lastName,
      Timestamp? lastSeen,
      Map<String, dynamic>? metadata,
      Role? role,
      Timestamp? updatedAt,
      String? fullName,
      String? suburb});

  /// Converts user to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

/// A utility class to enable better copyWith.
class _User extends User {
  const _User(
      {super.createdAt,
      super.firstName,
      required super.id,
      super.imageUrl,
      super.lastName,
      super.lastSeen,
      super.metadata,
      super.role,
      super.updatedAt,
      super.fullName,
      super.suburb})
      : super._();

  @override
  User copyWith(
          {dynamic createdAt = _Unset,
          dynamic firstName = _Unset,
          String? id,
          dynamic imageUrl = _Unset,
          dynamic lastName = _Unset,
          dynamic lastSeen = _Unset,
          dynamic metadata = _Unset,
          dynamic role = _Unset,
          dynamic updatedAt = _Unset,
          dynamic fullName = _Unset,
          dynamic suburb = _Unset}) =>
      _User(
          createdAt:
              createdAt == _Unset ? this.createdAt : createdAt as Timestamp?,
          firstName:
              firstName == _Unset ? this.firstName : firstName as String?,
          id: id ?? this.id,
          imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl as String?,
          lastName: lastName == _Unset ? this.lastName : lastName as String?,
          lastSeen: lastSeen == _Unset ? this.lastSeen : lastSeen as Timestamp?,
          metadata: metadata == _Unset
              ? this.metadata
              : metadata as Map<String, dynamic>?,
          role: role == _Unset ? this.role : role as Role?,
          updatedAt:
              updatedAt == _Unset ? this.updatedAt : updatedAt as Timestamp?,
          fullName: fullName == _Unset ? this.fullName : fullName as String?,
          suburb: suburb == _Unset ? this.suburb : suburb as String?);

  @override
  set id(String _id) {
    // TODO: implement id
  }
}

class _Unset {}

// Test

User _$UserFromJson(Map<String, dynamic> json) => User(
      createdAt: json['createdAt'] as Timestamp?,
      firstName: json['firstName'] as String?,
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String?,
      lastName: json['lastName'] as String?,
      lastSeen: json['lastSeen'] as Timestamp?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
      updatedAt: json['updatedAt'] as Timestamp?,
      fullName: json['fullName'] as String?,
      suburb: json['suburb'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('firstName', instance.firstName);
  val['id'] = instance.id;
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('lastSeen', instance.lastSeen);
  writeNotNull('metadata', instance.metadata);
  writeNotNull('role', _$RoleEnumMap[instance.role]);
  writeNotNull('updatedAt', instance.updatedAt);
  writeNotNull('fullName', instance.updatedAt);
  writeNotNull('suburb', instance.updatedAt);
  return val;
}

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.agent: 'agent',
  Role.moderator: 'moderator',
  Role.user: 'user',
};
