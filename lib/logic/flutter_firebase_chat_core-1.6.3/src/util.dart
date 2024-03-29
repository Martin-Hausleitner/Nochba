import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nochba/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart'
    as types;
import 'package:nochba/logic/models/user.dart' as models;

/// Extension with one [toShortString] method.
extension RoleToShortString on models.Role {
  /// Converts enum to the string equal to enum's name.
  String toShortString() => toString().split('.').last;
}

/// Extension with one [toShortString] method.
extension RoomTypeToShortString on types.RoomType {
  /// Converts enum to the string equal to enum's name.
  String toShortString() => toString().split('.').last;
}

/// Fetches user from Firebase and returns a promise.
Future<Map<String, dynamic>> fetchUser(
  FirebaseFirestore instance,
  String userId,
  String usersCollectionName, {
  String? role,
}) async {
  final doc = await instance.collection(usersCollectionName).doc(userId).get();

  final data = doc.data()!;

  data['createdAt'] = data['createdAt'];
  data['id'] = doc.id;
  data['lastSeen'] = data['lastSeen'];
  data['role'] = role;
  data['updatedAt'] = data['updatedAt'];

  return data;
}

Future<Map<String, dynamic>?> fetchLastMessage(FirebaseFirestore instance,
    String roomId, String roomsCollectionName) async {
  final snapshot = await instance
      .collection('$roomsCollectionName/$roomId/messages')
      .orderBy('createdAt', descending: true)
      .get();
  if (snapshot.docs.isNotEmpty) {
    final data = snapshot.docs.first.data();
    return data;
  } else {
    return null;
  }
}

/// Returns a list of [types.Room] created from Firebase query.
/// If room has 2 participants, sets correct room name and image.
Future<List<types.Room>> processRoomsQuery(
  User firebaseUser,
  FirebaseFirestore instance,
  QuerySnapshot<Map<String, dynamic>> query,
  String usersCollectionName,
  String roomsCollectionName,
) async {
  final futures = query.docs.map(
    (doc) => processRoomDocument(
      doc,
      firebaseUser,
      instance,
      usersCollectionName,
      roomsCollectionName,
    ),
  );

  return await Future.wait(futures);
}

/// Returns a [types.Room] created from Firebase document.
Future<types.Room> processRoomDocument(
  DocumentSnapshot<Map<String, dynamic>> doc,
  User firebaseUser,
  FirebaseFirestore instance,
  String usersCollectionName,
  String roomsCollectionName,
) async {
  final data = doc.data()!;

  data['createdAt'] = data['createdAt'];
  data['id'] = doc.id;
  data['updatedAt'] = data['updatedAt'];

  var imageUrl = data['imageUrl'] as String?;
  var name = data['name'] as String?;
  var suburb = data['suburb'] as String?;
  final type = data['type'] as String;
  final userIds = data['userIds'] as List<dynamic>;
  final userRoles = data['userRoles'] as Map<String, dynamic>?;

  final users = await Future.wait(
    userIds.map(
      (userId) => fetchUser(
        instance,
        userId as String,
        usersCollectionName,
        role: userRoles?[userId] as String?,
      ),
    ),
  );

  if (type == types.RoomType.direct.toShortString()) {
    try {
      final otherUser = users.firstWhere(
        (u) => u['id'] != firebaseUser.uid,
      );

      imageUrl = otherUser['imageUrl'] as String?;
      name = '${otherUser['fullName'] ?? ''}'.trim();
      suburb = '${otherUser['suburb'] ?? ''}'.trim();
    } catch (e) {
      // Do nothing if other user is not found, because he should be found.
      // Consider falling back to some default values.
    }
  }

  data['imageUrl'] = imageUrl;
  data['name'] = name;
  data['suburb'] = suburb;
  data['users'] = users;

  final lastMessage = await fetchLastMessage(
    instance,
    data['id'],
    roomsCollectionName,
  );

  if (lastMessage != null) {
    if (lastMessage['type'] == 'text') {
      data['lastMessage'] = lastMessage['text'];
    } else if (lastMessage['type'] == 'image') {
      data['lastMessage'] = lastMessage['name'];
    } else if (lastMessage['type'] == 'file') {
      data['lastMessage'] = lastMessage['name'];
    }
  } else {
    data['lastMessage'] = null;
  }

  if (data['lastMessages'] != null) {
    final lastMessages = data['lastMessages'].map((lm) {
      final author = users.firstWhere(
        (u) => u['id'] == lm['authorId'],
        orElse: () => {'id': lm['authorId'] as String},
      );

      lm['author'] = author;
      lm['createdAt'] = lm['createdAt'];
      lm['id'] = lm['id'] ?? '';
      lm['updatedAt'] = lm['updatedAt'];

      return lm;
    }).toList();

    data['lastMessages'] = lastMessages;
  }

  return types.Room.fromJson(data);
}
