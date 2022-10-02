import 'package:nochba/logic/models/UserPublicInfo.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class UserPublicInfoRepository extends GenericRepository<UserPublicInfo> {
  UserPublicInfoRepository(super.resourceContext);

  Stream<UserPublicInfo?> getPublicInfoOfCurrentUser() {
    return resource
        .getAsStream(resourceContext.uid, nexus: [resourceContext.uid]);
  }
}
