import 'package:get/get.dart';
import 'package:locoo/logic/models/user.dart';
import 'package:locoo/logic/repositories/GenericRepository.dart';

class UserRepository extends GenericRepository<User> {
  UserRepository(super.resourceContext);

  Future<User?> getCurrentUser() {
    try {
      return get(resourceContext.uid);
    } on Exception {
      rethrow;
    }
  }
}