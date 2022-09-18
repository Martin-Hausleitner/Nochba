import 'package:get/get.dart';

class ChatController extends GetxController {
  final Rx<bool> _isAttachmentUploading = false.obs;

  bool get isAttachmentUploading => _isAttachmentUploading.value;

  setAttachmentUpload(bool isAttachmentUploading) {
    _isAttachmentUploading.value = isAttachmentUploading;
  }
}