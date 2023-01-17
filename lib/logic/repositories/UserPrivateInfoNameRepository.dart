import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPrivateInfoName.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoSettingsRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class UserPrivateInfoNameRepository
    extends GenericRepository<UserPrivateInfoName> {
  UserPrivateInfoNameRepository(super.resourceContext);

  @override
  String get reference => 'name';

  @override
  Future afterAction(AccessMode accessMode,
      {UserPrivateInfoName? model, String? id}) async {
    if ((accessMode == AccessMode.insert || accessMode == AccessMode.update) &&
        model != null) {
      final userRepository = Get.find<UserRepository>();
      final userPrivateInfoSettingsRepository =
          Get.find<UserPrivateInfoSettingsRepository>();

      final lastNameInitialOnly = await userPrivateInfoSettingsRepository
          .getField<bool>(userPrivateInfoSettingsRepository.reference,
              'lastNameInitialOnly',
              nexus: [resourceContext.uid]);

      if (lastNameInitialOnly != null) {
        userRepository.updateFields(resourceContext.uid, {
          'fullName': lastNameInitialOnly
              ? '${model.firstName} ${model.lastName.substring(0, 1)}.'
              : '${model.firstName} ${model.lastName}'
        });
      }
    } else if (accessMode == AccessMode.updateFields && id != null) {
      final userRepository = Get.find<UserRepository>();
      final userPrivateInfoSettingsRepository =
          Get.find<UserPrivateInfoSettingsRepository>();

      final lastNameInitialOnly = await userPrivateInfoSettingsRepository
          .getField<bool>(userPrivateInfoSettingsRepository.reference,
              'lastNameInitialOnly',
              nexus: [resourceContext.uid]);

      final model = await get(reference, nexus: [resourceContext.uid]);

      if (model != null && lastNameInitialOnly != null) {
        userRepository.updateFields(resourceContext.uid, {
          'fullName': lastNameInitialOnly
              ? '${model.firstName} ${model.lastName.substring(0, 1)}.'
              : '${model.firstName} ${model.lastName}'
        });
      }
    }
  }

  Stream<UserPrivateInfoName?> getCurrentUserAsStream() {
    try {
      return getAsStream(reference, nexus: [resourceContext.uid]);
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateNameOfCurrentUser(
      String firstName, String lastName) async {
    try {
      return await updateFields(
          reference, {"firstName": firstName, "lastName": lastName},
          nexus: [resourceContext.uid]);
    } on Exception {
      rethrow;
    }
  }
}
