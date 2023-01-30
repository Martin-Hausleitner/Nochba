import 'package:nochba/logic/models/UserPrivateInfoAddress.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';

class UserPrivateInfoAddressRepository
    extends GenericRepository<UserPrivateInfoAddress> {
  UserPrivateInfoAddressRepository(super.resourceContext);

  @override // TODO: implement reference
  String get reference => 'address';
}
