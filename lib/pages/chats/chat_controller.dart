import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/auth/AuthService.dart';
import 'package:nochba/logic/models/user.dart';

class ChatController extends GetxController {
  final Rx<bool> _isAttachmentUploading = false.obs;

  bool get isAttachmentUploading => _isAttachmentUploading.value;

  setAttachmentUpload(bool isAttachmentUploading) {
    _isAttachmentUploading.value = isAttachmentUploading;
  }

  final _authSerive = Get.find<AuthService>();

  Future<String> getDistanceToUser(List<User> users) async {
    final currentUser = _authSerive.uid;

    final otherUser = users
        .firstWhere(
          (u) => u.id != currentUser,
        )
        .id;

    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
        'getDistanceToOtherUser',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      final result = await callable.call(<String, dynamic>{
        'userId': otherUser,
      });

      return result.data;
    } catch (e) {
      return '---';
    }
  }
}
