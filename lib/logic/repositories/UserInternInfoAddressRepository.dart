import 'package:nochba/logic/models/UserInternInfoAddress.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class UserInternInfoAddressRepository
    extends GenericRepository<UserInternInfoAddress> {
  UserInternInfoAddressRepository(super.resourceContext);

  @override
  String get reference => 'address';
}
