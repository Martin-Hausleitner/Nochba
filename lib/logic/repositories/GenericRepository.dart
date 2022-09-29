import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locoo/logic/interfaces/IModel.dart';
import 'package:locoo/logic/repositories/RepositoryObject.dart';

enum AccessMode {
  getAll,
  get,
  insert,
  update,
  delete,
  query
}

abstract class GenericRepository<T extends IModel> extends RepositoryObject<T> {
  GenericRepository(super.resourceContext);

  void validate(T? model, AccessMode accessMode) {
    
  }

  void beforeAction(T? model, AccessMode accessMode) {

  }

  Stream<List<T>> getAll({MapEntry<String, bool>? orderFieldDescending, List<String>? nexus}) {
    validate(null, AccessMode.getAll);
    try {
      return resource.getAll(orderFieldDescending: orderFieldDescending, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Future<T?> get(String id, {List<String>? nexus}) async {
    validate(null, AccessMode.get);
    try {
      return resource.get(id, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Stream<T?> getAsStream(String id, {List<String>? nexus}) {
    validate(null, AccessMode.get);
    try {
      return resource.getAsStream(id, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Future<void> update(T model, {List<String>? nexus}) async {
    validate(model, AccessMode.update);
    try {
      return resource.update(model, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateFields(String id, Map<String, dynamic> fields, {List<String>? nexus}) async {
    //validate(model, AccessMode.update);
    try {
      return resource.updateFields(id, fields, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Future<void> insert(T model, {List<String>? nexus}) async {
    validate(model, AccessMode.insert);
    try {
      return resource.insert(model, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Future<void> delete(String id, {List<String>? nexus}) async {
    validate(null, AccessMode.delete);
    try {
      return resource.delete(id, nexus: nexus);
    } on Exception {
      rethrow;
    }
  }

  Stream<List<T>> query(MapEntry<String, bool> orderFieldDescending, {
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
    validate(null, AccessMode.query);
    try {
      return resource.query(orderFieldDescending,
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
        whereIsEqualTo: whereIsEqualTo,
        whereIsNotEqualTo: whereIsNotEqualTo,
        nexus: nexus,
      );
    } on Exception {
      rethrow;
    }
  }
}