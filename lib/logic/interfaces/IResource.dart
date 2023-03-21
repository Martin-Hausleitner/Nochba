import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nochba/logic/interfaces/IModel.dart';

abstract class IResource<T extends IModel> {
  Stream<List<T>> getAll({MapEntry<String, bool>? orderFieldDescending});
  Future<T?> get(String id);
  Stream<T?> getAsStream(String id);
  Future<T?> getWhere(Map<String, dynamic> fields);
  Future<List<T>> getAllWhereIn(MapEntry<String, List<Object?>?> whereIn);
  Future<void> update(T post);
  Future<void> updateFields(String id, Map<String, dynamic> fields);
  Future<void> insert(T post);
  Future<void> delete(String id);

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
  });

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
  });
}
