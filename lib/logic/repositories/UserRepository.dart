import 'package:get/get.dart';
import 'package:nochba/logic/models/user.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class UserRepository extends GenericRepository<User> {
  UserRepository(super.resourceContext);

  Future<User?> getCurrentUser() async {
    try {
      return await get(resourceContext.uid);
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

  Future<void> updateNameOfCurrentUser(
      String firstName, String lastName) async {
    try {
      return await updateFields(
          resourceContext.uid, {"firstName": firstName, "lastName": lastName});
    } on Exception {
      rethrow;
    }
  }
}
