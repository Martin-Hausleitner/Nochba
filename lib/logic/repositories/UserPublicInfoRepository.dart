import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class UserPublicInfoRepository extends GenericRepository<UserPublicInfo> {
  UserPublicInfoRepository(super.resourceContext);

  @override
  String get reference => 'data';

  Stream<UserPublicInfo?> getPublicInfoOfCurrentUserAsStream() {
    return resource.getAsStream(reference, nexus: [resourceContext.uid]);
  }

  Future<UserPublicInfo?> getPublicInfoOfCurrentUser() async {
    return await resource.get(reference, nexus: [resourceContext.uid]);
  }

  Future<UserPublicInfo?> getPublicInfoOfUser(String id) async {
    return await get(reference, nexus: [id]);
  }

  Future<void> updateProfessionOfCurrentUser(String profession) async {
    try {
      return await updateFields(reference, {
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
      return await updateFields(reference, {
        "bio": bio,
      }, nexus: [
        resourceContext.uid
      ]);
    } on Exception {
      rethrow;
    }
  }
}
