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

  Stream<User?> getCurrentUserAsStream() {
    try {
      return getAsStream(resourceContext.uid);
    } on Exception {
      rethrow;
    }
  }

  Future updateNameOfCurrentUser(String firstName, String lastName) {
    try {
      return updateFields(
          resourceContext.uid, {"firstName": firstName, "lastName": lastName});
    } on Exception {
      rethrow;
    }
  }
}
