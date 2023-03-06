import 'package:get/get.dart';
import 'package:nochba/logic/models/UserPrivateInfoSettings.dart';
import 'package:nochba/logic/repositories/GenericRepository.dart';
import 'package:nochba/logic/repositories/UserPrivateInfoNameRepository.dart';
import 'package:nochba/logic/repositories/UserRepository.dart';

class UserPrivateInfoSettingsRepository
    extends GenericRepository<UserPrivateInfoSettings> {
  UserPrivateInfoSettingsRepository(super.resourceContext);

  @override
  Future afterAction(AccessMode accessMode,
      {UserPrivateInfoSettings? model, String? id}) async {
    if ((accessMode == AccessMode.insert || accessMode == AccessMode.update) &&
        (model != null)) {
      final userRepository = Get.find<UserRepository>();
      final userPrivateInfoNameRepository =
          Get.find<UserPrivateInfoNameRepository>();

      final userPrivateInfoName = await userPrivateInfoNameRepository.get(
          userPrivateInfoNameRepository.reference,
          nexus: [resourceContext.uid]);

      if (userPrivateInfoName != null) {
        await userRepository.updateFields(resourceContext.uid, {
          'fullName': model.lastNameInitialOnly
              ? '${userPrivateInfoName.firstName} ${userPrivateInfoName.lastName.substring(0, 1)}.'
              : '${userPrivateInfoName.firstName} ${userPrivateInfoName.lastName}'
        });
      }
    } else if (accessMode == AccessMode.updateFields && id != null) {
      final userRepository = Get.find<UserRepository>();
      final userPrivateInfoNameRepository =
          Get.find<UserPrivateInfoNameRepository>();

      final userPrivateInfoName = await userPrivateInfoNameRepository.get(
          userPrivateInfoNameRepository.reference,
          nexus: [resourceContext.uid]);

      final lastNameInitialOnly = await getField<bool>(
          reference, 'lastNameInitialOnly',
          nexus: [resourceContext.uid]);

      if (userPrivateInfoName != null && lastNameInitialOnly != null) {
        await userRepository.updateFields(resourceContext.uid, {
          'fullName': lastNameInitialOnly
              ? '${userPrivateInfoName.firstName} ${userPrivateInfoName.lastName.substring(0, 1)}.'
              : '${userPrivateInfoName.firstName} ${userPrivateInfoName.lastName}'
        });
      }
    }
  }

  @override
  String get reference => 'settings';

  Stream<bool?> getLastNameInitialOnlyOfCurrentUser() {
    try {
      return getFieldAsStream(reference, 'lastNameInitialOnly',
          nexus: [resourceContext.uid]);
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateLastNameInitialOnlyOfCurrentUser(bool value) async {
    try {
      return await updateFields(reference, {"lastNameInitialOnly": value},
          nexus: [resourceContext.uid]);
    } on Exception {
      rethrow;
    }
  }

  Stream<bool?> getPermReqBeforeChatOfCurrentUser() {
    try {
      return getFieldAsStream(reference, 'permReqBeforeChat',
          nexus: [resourceContext.uid]);
    } on Exception {
      rethrow;
    }
  }

  Future<void> updatePermReqBeforeChatOfCurrentUser(bool value) async {
    try {
      return await updateFields(reference, {"permReqBeforeChat": value},
          nexus: [resourceContext.uid]);
    } on Exception {
      rethrow;
    }
  }
}
