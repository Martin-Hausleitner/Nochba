import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:nochba/logic/interfaces/IModel.dart';
import 'package:nochba/logic/repositories/RepositoryObject.dart';

enum AccessMode {
  getAll,
  get,
  getField,
  getWhere,
  getAllWhereIn,
  insert,
  update,
  updateFields,
  delete,
  query
}

abstract class GenericRepository<T extends IModel> extends RepositoryObject<T> {
  GenericRepository(super.resourceContext);

  final String reference = '';

  Future validate(T? model, AccessMode accessMode) async {}

  Future beforeAction(AccessMode accessMode, {T? model, String? id}) async {}
  Future afterAction(AccessMode accessMode, {T? model, String? id}) async {}
  Stream<List<T>> processStreamListResult(Stream<List<T>> result) => result;
  Stream<T?> processStreamResult(Stream<T?> result) => result;
  Future<List<T>> processFutureListResult(Future<List<T>> result) async =>
      result;
  Future<T?> processFutureResult(Future<T?> result) async => result;

  Stream<List<T>> getAll(
      {MapEntry<String, bool>? orderFieldDescending, List<String>? nexus}) {
    validate(null, AccessMode.getAll);
    try {
      beforeAction(AccessMode.getAll);

      final result = resource.getAll(
          orderFieldDescending: orderFieldDescending, nexus: nexus);

      afterAction(AccessMode.getAll);
      return processStreamListResult(result);
    } on Exception {
      rethrow;
    }
  }

  Future<T?> get(String id, {List<String>? nexus}) async {
    await validate(null, AccessMode.get);
    try {
      await beforeAction(AccessMode.get, id: id);

      final result = resource.get(id, nexus: nexus);

      await afterAction(AccessMode.get, id: id);
      return processFutureResult(result);
    } on Exception {
      rethrow;
    }
  }

  Stream<T?> getAsStream(String id, {List<String>? nexus}) {
    validate(null, AccessMode.get);
    try {
      beforeAction(AccessMode.get, id: id);

      final result = resource.getAsStream(id, nexus: nexus);

      afterAction(AccessMode.get, id: id);
      return processStreamResult(result);
    } on Exception {
      rethrow;
    }
  }

  Future<F?> getField<F>(String id, String fieldName, {List<String>? nexus}) {
    validate(null, AccessMode.getField);
    try {
      beforeAction(AccessMode.getField, id: id);

      final result = resource.getField<F>(id, fieldName, nexus: nexus);

      afterAction(AccessMode.getField, id: id);
      return result;
    } on Exception {
      rethrow;
    }
  }

  Stream<F?> getFieldAsStream<F>(String id, String fieldName,
      {List<String>? nexus}) {
    validate(null, AccessMode.getField);
    try {
      beforeAction(AccessMode.getField, id: id);

      final result = resource.getFieldAsStream<F>(id, fieldName, nexus: nexus);

      afterAction(AccessMode.getField, id: id);
      return result;
    } on Exception {
      rethrow;
    }
  }

  Future<T?> getWhere(Map<String, dynamic> fields,
      {List<String>? nexus}) async {
    await validate(null, AccessMode.getWhere);
    try {
      await beforeAction(AccessMode.getWhere);

      final result = resource.getWhere(fields, nexus: nexus);

      await afterAction(AccessMode.getWhere);
      return processFutureResult(result);
    } on Exception {
      rethrow;
    }
  }

  Future<List<T>> getAllWhereIn(MapEntry<String, List<Object?>?> whereIn,
      {List<String>? nexus}) async {
    await validate(null, AccessMode.getAllWhereIn);

    await beforeAction(AccessMode.getAllWhereIn);

    final result = resource.getAllWhereIn(whereIn, nexus: nexus);

    await afterAction(AccessMode.getAllWhereIn);
    return processFutureListResult(result);
  }

  Future<void> update(T model, {List<String>? nexus}) async {
    await validate(model, AccessMode.update);
    try {
      await beforeAction(AccessMode.update, model: model);

      final result = resource.update(model, nexus: nexus);

      await afterAction(AccessMode.update, model: model);
      return result;
    } on Exception {
      rethrow;
    }
  }

  Future<int> getSize({List<String>? nexus}) async {
    try {
      final result = resource.getSize(nexus: nexus);

      return result;
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateFields(String id, Map<String, dynamic> fields,
      {List<String>? nexus}) async {
    await validate(null, AccessMode.updateFields);
    try {
      await beforeAction(AccessMode.updateFields, id: id);

      final result = resource.updateFields(id, fields, nexus: nexus);

      await afterAction(AccessMode.updateFields, id: id);
      return result;
    } on Exception {
      rethrow;
    }
  }

  Future<void> insert(T model, {List<String>? nexus}) async {
    await validate(model, AccessMode.insert);
    try {
      await beforeAction(AccessMode.insert, model: model);

      final result = resource.insert(model, nexus: nexus);

      await afterAction(AccessMode.insert, model: model);
      return result;
    } on Exception {
      rethrow;
    }
  }

  Future<void> delete(String id, {List<String>? nexus}) async {
    await validate(null, AccessMode.delete);
    try {
      await beforeAction(AccessMode.delete, id: id);

      final result = resource.delete(id, nexus: nexus);

      await afterAction(AccessMode.delete, id: id);
      return result;
    } on Exception {
      rethrow;
    }
  }

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
    Map<String, List<Object?>?>? whereIn,
    MapEntry<String, List<Object?>?>? whereNotIn,
    Map<String, dynamic>? whereIsEqualTo,
    Map<String, dynamic>? whereIsNotEqualTo,
    List<String>? nexus,
  }) async {
    await validate(null, AccessMode.query);
    try {
      await beforeAction(AccessMode.query);

      final result = resource.query(
        orderFieldDescending,
        limit: limit,
        limitToLast: limitToLast,
        startAtDocument: startAtDocument,
        startAfterDocument: startAfterDocument,
        endAtDocument: endAtDocument,
        endBeforeDocument: endBeforeDocument,
        startAfter: startAfter,
        startAt: startAt,
        endAt: endAt,
        endBefore: endBefore,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        whereIsEqualTo: whereIsEqualTo,
        whereIsNotEqualTo: whereIsNotEqualTo,
        nexus: nexus,
      );

      await afterAction(AccessMode.query);
      return processFutureListResult(result);
    } on Exception {
      rethrow;
    }
  }

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
    Map<String, List<Object?>?>? whereIn,
    MapEntry<String, List<Object?>?>? whereNotIn,
    Map<String, dynamic>? whereIsEqualTo,
    Map<String, dynamic>? whereIsNotEqualTo,
    List<String>? nexus,
  }) {
    validate(null, AccessMode.query);
    try {
      beforeAction(AccessMode.query);

      final result = resource.queryAsStream(
        orderFieldDescending,
        limit: limit,
        limitToLast: limitToLast,
        startAtDocument: startAtDocument,
        startAfterDocument: startAfterDocument,
        endAtDocument: endAtDocument,
        endBeforeDocument: endBeforeDocument,
        startAfter: startAfter,
        startAt: startAt,
        endAt: endAt,
        endBefore: endBefore,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        whereIsEqualTo: whereIsEqualTo,
        whereIsNotEqualTo: whereIsNotEqualTo,
        nexus: nexus,
      );

      afterAction(AccessMode.query);
      return processStreamListResult(result);
    } on Exception {
      rethrow;
    }
  }
}
