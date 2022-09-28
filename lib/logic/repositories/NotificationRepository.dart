import 'package:locoo/logic/models/Notification.dart';
import 'package:locoo/logic/repositories/GenericRepository.dart';

class NotificationRepository extends GenericRepository<Notification> {
  NotificationRepository(super.resourceContext);
  
  Stream<List<Notification>> getNotifiactionsOfCurrentUser() {
    try {
      return getAll(orderFieldDescending: const MapEntry('createdAt', true), nexus: [resourceContext.uid]);
      /*return query(const MapEntry('createdAt', true), 
        whereIsEqualTo: {'toUser': resourceContext.uid}
      );*/
    } on Exception {
      rethrow;
    }
  }
}