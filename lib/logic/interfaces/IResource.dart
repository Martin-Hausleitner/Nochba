import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locoo/logic/interfaces/IModel.dart';

abstract class IResource<T extends IModel> {
    
    Stream<List<T>> getAll({MapEntry<String, bool>? orderFieldDescending});
    Future<T?> get(String id);
    Stream<T?> getAsStream(String id);
    Future<void> update(T post);
    Future<void> updateFields(String id, Map<String, dynamic> fields);
    Future<void> insert(T post);
    Future<void> delete(String id);

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
    });
}