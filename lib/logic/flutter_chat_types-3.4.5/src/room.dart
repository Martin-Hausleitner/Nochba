import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';
import '../../models/user.dart';

part 'room.g.dart';

/// All possible room types.
enum RoomType { channel, direct, group }

/// A class that represents a room where 2 or more participants can chat.
@JsonSerializable()
@immutable
abstract class Room extends Equatable {
  /// Creates a [Room].
  const Room._({
    this.createdAt,
    required this.id,
    this.imageUrl,
    this.lastMessages,
    this.metadata,
    this.name,
    this.suburb,
    required this.type,
    this.updatedAt,
    required this.users,
    this.lastMessage,
  });

  const factory Room({
    Timestamp? createdAt,
    required String id,
    String? imageUrl,
    List<Message>? lastMessages,
    Map<String, dynamic>? metadata,
    String? name,
    String? suburb,
    required RoomType? type,
    Timestamp? updatedAt,
    required List<User> users,
    String? lastMessage,
  }) = _Room;

  /// Creates room from a map (decoded JSON).
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  /// Created room timestamp, in ms.
  final Timestamp? createdAt;

  /// Room's unique ID.
  final String id;

  /// Room's image. In case of the [RoomType.direct] - avatar of the second person,
  /// otherwise a custom image [RoomType.group].
  final String? imageUrl;

  /// List of last messages this room has received.
  final List<Message>? lastMessages;

  /// Additional custom metadata or attributes related to the room.
  final Map<String, dynamic>? metadata;

  /// Room's name. In case of the [RoomType.direct] - name of the second person,
  /// otherwise a custom name [RoomType.group].
  final String? name;

  /// Suburb of the other user
  final String? suburb;

  /// [RoomType].
  final RoomType? type;

  /// Updated room timestamp, in ms.
  final Timestamp? updatedAt;

  /// List of users which are in the room.
  final List<User> users;

  final String? lastMessage;

  /// Equatable props.
  @override
  List<Object?> get props => [
        createdAt,
        id,
        imageUrl,
        lastMessages,
        metadata,
        name,
        suburb,
        type,
        updatedAt,
        users,
        lastMessage,
      ];

  /// Creates a copy of the room with an updated data.
  /// [imageUrl], [name] and [updatedAt] with null values will nullify existing values
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [type] and [users] with null values will be overwritten by previous values.
  Room copyWith({
    int? createdAt,
    String? id,
    String? imageUrl,
    List<Message>? lastMessages,
    Map<String, dynamic>? metadata,
    String? name,
    String? suburb,
    RoomType? type,
    int? updatedAt,
    List<User>? users,
  });

  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

/// A utility class to enable better copyWith.
class _Room extends Room {
  const _Room({
    super.createdAt,
    required super.id,
    super.imageUrl,
    super.lastMessages,
    super.metadata,
    super.name,
    super.suburb,
    required super.type,
    super.updatedAt,
    required super.users,
    super.lastMessage,
  }) : super._();

  @override
  Room copyWith({
    dynamic createdAt = _Unset,
    String? id,
    dynamic imageUrl = _Unset,
    dynamic lastMessages = _Unset,
    dynamic metadata = _Unset,
    dynamic name = _Unset,
    dynamic suburb = _Unset,
    dynamic type = _Unset,
    dynamic updatedAt = _Unset,
    List<User>? users,
    String? lastMessage,
  }) =>
      _Room(
        createdAt:
            createdAt == _Unset ? this.createdAt : createdAt as Timestamp?,
        id: id ?? this.id,
        imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl as String?,
        lastMessages: lastMessages == _Unset
            ? this.lastMessages
            : lastMessages as List<Message>?,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        name: name == _Unset ? this.name : name as String?,
        suburb: suburb == _Unset ? this.suburb : suburb as String?,
        type: type == _Unset ? this.type : type as RoomType?,
        updatedAt:
            updatedAt == _Unset ? this.updatedAt : updatedAt as Timestamp?,
        users: users ?? this.users,
        lastMessage: lastMessage ?? this.lastMessage,
      );
}

class _Unset {}
