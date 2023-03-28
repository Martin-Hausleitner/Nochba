import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:nochba/logic/interfaces/IModelMapper.dart';
import 'package:nochba/logic/interfaces/IResource.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/commonbase/util.dart';

class Resource<T extends IModel> implements IResource<T> {
  Resource({required this.getCollectionName, required this.modelMapper});

  final IModelMapper modelMapper;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  GeoFlutterFire geoflutterfire = GeoFlutterFire();

  Map<String, dynamic> convertModelToJson(T model) {
    return modelMapper.getJsonFromModel<T>(model);
  }

  T convertJsonToModel(String id, Map<String, dynamic> json) {
    return modelMapper.getModelFromJson<T>(id, json);
  }

  final String Function(Type type, {List<String>? nexus}) getCollectionName;

  @override
  Stream<List<T>> getAll(
      {MapEntry<String, bool>? orderFieldDescending, List<String>? nexus}) {
    return orderFieldDescending != null
        ? firestoreInstance
            .collection(getCollectionName(typeOf<T>(), nexus: nexus))
            .orderBy(orderFieldDescending.key,
                descending: orderFieldDescending.value)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => convertJsonToModel(doc.id, doc.data()))
                .toList())
        : firestoreInstance
            .collection(getCollectionName(typeOf<T>(), nexus: nexus))
            .snapshots()
            .asyncMap((snapshot) => snapshot.docs
                .map((doc) => convertJsonToModel(doc.id, doc.data()))
                .toList());
  }

  @override
  Future<T?> get(String id, {List<String>? nexus}) async {
    final snapshot = await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .get();

    if (snapshot.exists) {
      return convertJsonToModel(snapshot.id, snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  Stream<T?> getAsStream(String id, {List<String>? nexus}) {
    return firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return convertJsonToModel(doc.id, doc.data()!);
      } else {
        return null;
      }
    });
  }

  Future<F?> getField<F>(String id, String fieldName,
      {List<String>? nexus}) async {
    final snapshot = await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .get();

    if (snapshot.exists) {
      return snapshot.get(fieldName);
    } else {
      return null;
    }
  }

  @override
  Stream<F?> getFieldAsStream<F>(String id, String fieldName,
      {List<String>? nexus}) {
    return firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return doc.get(fieldName);
      } else {
        return null;
      }
    });
  }

  @override
  Future<T?> getWhere(Map<String, dynamic> fields,
      {List<String>? nexus}) async {
    if (fields.isNotEmpty) {
      var query = firestoreInstance
          .collection(getCollectionName(typeOf<T>(), nexus: nexus))
          .where(fields.keys.first, isEqualTo: fields.values.first);

      for (int i = 1; i < fields.length; i++) {
        MapEntry<String, dynamic> field = fields.entries.elementAt(i);
        query = query.where(field.key, isEqualTo: field.value);
      }
      query = query.limit(1);

      final snapshots = await query.get();
      if (snapshots.docs.isNotEmpty) {
        final snapshot = snapshots.docs.first;
        return convertJsonToModel(snapshot.id, snapshot.data());
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<List<T>> getAllWhereIn(MapEntry<String, List<Object?>?> whereIn,
      {List<String>? nexus}) async {
    var snapshots = await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .where(whereIn.key, whereIn: whereIn.value)
        .get();

    if (snapshots.docs.isNotEmpty) {
      return snapshots.docs
          .map((snapshot) => convertJsonToModel(snapshot.id, snapshot.data()))
          .toList();
    } else {
      return List.empty();
    }
  }

  @override
  Future<int> getSize({List<String>? nexus}) async {
    var snapshots = await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .get();

    if (snapshots.docs.isNotEmpty) {
      return snapshots.size;
    } else {
      return 0;
    }
  }

  @override
  Stream<bool?> any(Map<String, dynamic> fields, {List<String>? nexus}) {
    if (fields.isNotEmpty) {
      var query = firestoreInstance
          .collection(getCollectionName(typeOf<T>(), nexus: nexus))
          .where(fields.keys.first, isEqualTo: fields.values.first);

      for (int i = 1; i < fields.length; i++) {
        MapEntry<String, dynamic> field = fields.entries.elementAt(i);
        query = query.where(field.key, isEqualTo: field.value);
      }
      query = query.limit(1);

      return query.snapshots().map((doc) {
        return doc.docs.isNotEmpty;
      });
    } else {
      return Stream.value(null);
    }
  }

  @override
  Future<void> update(T model, {List<String>? nexus}) async {
    return await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(model.id)
        .update(convertModelToJson(model));
  }

  @override
  Future<void> updateFields(String id, Map<String, dynamic> fields,
      {List<String>? nexus}) async {
    return await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .update(fields);
  }

  @override
  Future<void> insert(T model, {List<String>? nexus}) async {
    final DocumentReference<Map<String, dynamic>> doc;
    if (model.id.isEmpty) {
      doc = firestoreInstance
          .collection(getCollectionName(typeOf<T>(), nexus: nexus))
          .doc();
      model.id = doc.id;
    } else {
      doc = firestoreInstance
          .collection(getCollectionName(typeOf<T>(), nexus: nexus))
          .doc(model.id);
    }
    return await doc.set(convertModelToJson(model));
  }

  @override
  Future<void> delete(String id, {List<String>? nexus}) async {
    return await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .delete();
  }

  @override
  Future<List<T>> query(
    MapEntry<String, bool> orderFieldDescending, {
    int? limit,
    int? limitToLast,
    DocumentSnapshot<Object?>? startAtDocument,
    DocumentSnapshot<Object?>? startAfterDocument,
    DocumentSnapshot<Object?>? endAtDocument,
    DocumentSnapshot<Object?>? endBeforeDocument,
    List<Object?>? startAfter,
    List<Object?>? startAt,
    List<Object?>? endAt,
    List<Object?>? endBefore,
    MapEntry<String, List<Object?>?>? whereIn,
    MapEntry<String, List<Object?>?>? whereNotIn,
    Map<String, dynamic>? whereIsEqualTo,
    Map<String, dynamic>? whereIsNotEqualTo,
    List<String>? nexus,
  }) async {
    var query = firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .orderBy(orderFieldDescending.key,
            descending: orderFieldDescending.value);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument);
    }

    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument);
    }

    if (startAfter != null) {
      query = query.startAfter(startAfter);
    }

    if (startAt != null) {
      query = query.startAt(startAt);
    }

    if (endAt != null) {
      query = query.endAt(endAt);
    }

    if (endBefore != null) {
      query = query.endBefore(endBefore);
    }

    if (whereIn != null && whereIn.value!.isNotEmpty) {
      query = query.where(whereIn.key, whereIn: whereIn.value);
    }

    if (whereNotIn != null) {
      query = query.where(whereNotIn.key, whereNotIn: whereNotIn.value);
    }

    if (whereIsEqualTo != null) {
      for (var entry in whereIsEqualTo.entries) {
        query = query.where(entry.key, isEqualTo: entry.value);
      }
    }

    if (whereIsNotEqualTo != null) {
      for (var entry in whereIsNotEqualTo.entries) {
        query = query.where(entry.key, isNotEqualTo: entry.value);
      }
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    if (limitToLast != null) {
      query = query.limitToLast(limitToLast);
    }

    final snapshots = await query.get();

    return snapshots.docs
        .map((snapshot) => convertJsonToModel(snapshot.id, snapshot.data()))
        .toList();
  }

  @override
  Stream<List<T>> queryAsStream(
    MapEntry<String, bool> orderFieldDescending, {
    int? limit,
    int? limitToLast,
    DocumentSnapshot<Object?>? startAtDocument,
    DocumentSnapshot<Object?>? startAfterDocument,
    DocumentSnapshot<Object?>? endAtDocument,
    DocumentSnapshot<Object?>? endBeforeDocument,
    List<Object?>? startAfter,
    List<Object?>? startAt,
    List<Object?>? endAt,
    List<Object?>? endBefore,
    MapEntry<String, List<Object?>?>? whereIn,
    MapEntry<String, List<Object?>?>? whereNotIn,
    Map<String, dynamic>? whereIsEqualTo,
    Map<String, dynamic>? whereIsNotEqualTo,
    List<String>? nexus,
  }) {
    var query = firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .orderBy(orderFieldDescending.key,
            descending: orderFieldDescending.value);

    if (startAtDocument != null) {
      query = query.startAtDocument(startAtDocument);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    if (endAtDocument != null) {
      query = query.endAtDocument(endAtDocument);
    }

    if (endBeforeDocument != null) {
      query = query.endBeforeDocument(endBeforeDocument);
    }

    if (startAfter != null) {
      query = query.startAfter(startAfter);
    }

    if (startAt != null) {
      query = query.startAt(startAt);
    }

    if (endAt != null) {
      query = query.endAt(endAt);
    }

    if (endBefore != null) {
      query = query.endBefore(endBefore);
    }

    if (whereIn != null && whereIn.value!.isNotEmpty) {
      query = query.where(whereIn.key, whereIn: whereIn.value);
    }

    if (whereNotIn != null) {
      query = query.where(whereNotIn.key, whereNotIn: whereNotIn.value);
    }

    if (whereIsEqualTo != null) {
      for (var entry in whereIsEqualTo.entries) {
        query = query.where(entry.key, isEqualTo: entry.value);
      }
    }

    if (whereIsNotEqualTo != null) {
      for (var entry in whereIsNotEqualTo.entries) {
        query = query.where(entry.key, isNotEqualTo: entry.value);
      }
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    if (limitToLast != null) {
      query = query.limitToLast(limitToLast);
    }

    return query.snapshots().asyncMap((snapshot) => snapshot.docs
        .map((doc) => convertJsonToModel(doc.id, doc.data()))
        .toList());
  }
}
