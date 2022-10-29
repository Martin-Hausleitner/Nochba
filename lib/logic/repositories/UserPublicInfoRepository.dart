import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class UserPublicInfoRepository extends GenericRepository<UserPublicInfo> {
  UserPublicInfoRepository(super.resourceContext);

  Stream<UserPublicInfo?> getPublicInfoOfCurrentUserAsStream() {
    return resource
        .getAsStream(resourceContext.uid, nexus: [resourceContext.uid]);
  }

  Future<UserPublicInfo?> getPublicInfoOfCurrentUser() async {
    return await resource
        .get(resourceContext.uid, nexus: [resourceContext.uid]);
  }

  Future<UserPublicInfo?> getPublicInfoOfUser(String id) async {
    return await get(id, nexus: [id]);
  }

  Future<void> updateProfessionOfCurrentUser(String profession) async {
    try {
      return await updateFields(resourceContext.uid, {
        "profession": profession,
      }, nexus: [
        resourceContext.uid
      ]);
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateBioOfCurrentUser(String bio) async {
    try {
      return await updateFields(resourceContext.uid, {
        "bio": bio,
      }, nexus: [
        resourceContext.uid
      ]);
    } on Exception {
      rethrow;
    }
  }
}
