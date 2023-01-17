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

  Future<void> updateProfilePictureOfCurrentUser(String imageUrl) async {
    try {
      return await updateFields(resourceContext.uid, {"imageUrl": imageUrl});
    } on Exception {
      rethrow;
    }
  }
}
