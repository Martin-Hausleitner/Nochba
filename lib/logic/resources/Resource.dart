import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModelMapper.dart';
import 'package:nochba/logic/interfaces/IResource.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/commonbase/util.dart';

class Resource<T extends IModel> implements IResource<T> {
  Resource({required this.getCollectionName, required this.modelMapper});

  final IModelMapper modelMapper;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Map<String, dynamic> getJsonFromModel(T model) {
    return modelMapper.getJsonFromModel<T>(model);
  }

  T getModelFromJson(Map<String, dynamic> json) {
    return modelMapper.getModelFromJson<T>(json);
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
                .map((doc) => getModelFromJson(doc.data()))
                .toList())
        : firestoreInstance
            .collection(getCollectionName(typeOf<T>(), nexus: nexus))
            .snapshots()
            .asyncMap((snapshot) => snapshot.docs
                .map((doc) => getModelFromJson(doc.data()))
                .toList());
  }

  @override
  Future<T?> get(String id, {List<String>? nexus}) async {
    final snapshot = await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .get();

    if (snapshot.exists) {
      return getModelFromJson(snapshot.data()!);
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
        return getModelFromJson(doc.data()!);
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> update(T model, {List<String>? nexus}) async {
    return await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(model.id)
        .update(getJsonFromModel(model));
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
    final doc = firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc();
    model.id = doc.id;
    return await doc.set(getJsonFromModel(model));
  }

  @override
  Future<void> delete(String id, {List<String>? nexus}) async {
    return await firestoreInstance
        .collection(getCollectionName(typeOf<T>(), nexus: nexus))
        .doc(id)
        .delete();
  }

  @override
  Stream<List<T>> query(
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

    return query.snapshots().asyncMap((snapshot) =>
        snapshot.docs.map((doc) => getModelFromJson(doc.data())).toList());
  }
}
