import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:locoo/pages/chats/chat_controller.dart';
import 'package:mime/mime.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:locoo/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart' as types;
import 'package:locoo/logic/flutter_firebase_chat_core-1.6.3/flutter_firebase_chat_core.dart' as chat;
import 'package:locoo/logic/flutter_chat_ui-1.6.4/flutter_chat_ui.dart' as ui;

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key, required this.room}) : super(key: key);
    final types.Room room;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Scaffold(
        // ignore: unnecessary_new
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(1), // Border radius
                child: ClipOval(child: displayProfileImage()),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: displayProfileName())
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: StreamBuilder<types.Room>(
        initialData: room,
        stream: chat.FirebaseChatCore.instance.room(room.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: chat.FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) => Obx(() => ui.Chat(
            isAttachmentUploading: controller.isAttachmentUploading,
            messages: snapshot.data ?? [],
            onAttachmentPressed: () => _handleAtachmentPressed(context),
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: types.User(
              id: chat.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
            ),
          ),)
        ),
      ),
    );
  }

  void _handleAtachmentPressed(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 344,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  heightFactor: 2.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Photo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  heightFactor: 2.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select File',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  heightFactor: 2.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        chat.FirebaseChatCore.instance.sendMessage(message, room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        chat.FirebaseChatCore.instance.sendMessage(
          message,
          room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          chat.FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          chat.FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            room.id,
          );
        }
      }

      // await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    chat.FirebaseChatCore.instance.updateMessage(updatedMessage, room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    chat.FirebaseChatCore.instance.sendMessage(
      message,
      room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    final controller = Get.find<ChatController>();
    controller.setAttachmentUpload(uploading);
  }

  Image displayProfileImage() {
    String fullname =
        "${room.users[0].firstName} ${room.users[0].lastName}";
    if (room.name == fullname) {
      return Image.network('${room.users[0].imageUrl}');
    } else {
      return Image.network('${room.users[1].imageUrl}');
    }
  }

  Text displayProfileName() {
    String fullname =
        "${room.users[0].firstName} ${room.users[0].lastName}";
    if (room.name == fullname) {
      return Text(
        '${room.users[0].firstName} ${room.users[0].lastName}',
        style: const TextStyle(fontSize: 20),
      );
    } else {
      return Text(
        '${room.users[1].firstName} ${room.users[1].lastName}',
        style: const TextStyle(fontSize: 20),
      );
    }
  }
}


/*
class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        // ignore: unnecessary_new
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1), // Border radius
                  child: ClipOval(child: displayProfileImage()),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: displayProfileName())
            ],
          ),
        ),
        body: StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: chat.FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: chat.FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) => ui.Chat(
              isAttachmentUploading: _isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAtachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: chat.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
            ),
          ),
        ),
      );

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 344,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  heightFactor: 2.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Photo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  heightFactor: 2.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select File',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  heightFactor: 2.5,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        chat.FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        chat.FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          chat.FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          chat.FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      // await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    chat.FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    chat.FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  Image displayProfileImage() {
    String fullname =
        "${widget.room.users[0].firstName} ${widget.room.users[0].lastName}";
    if (widget.room.name == fullname) {
      return Image.network('${widget.room.users[0].imageUrl}');
    } else {
      return Image.network('${widget.room.users[1].imageUrl}');
    }
  }

  Text displayProfileName() {
    String fullname =
        "${widget.room.users[0].firstName} ${widget.room.users[0].lastName}";
    if (widget.room.name == fullname) {
      return Text(
        '${widget.room.users[0].firstName} ${widget.room.users[0].lastName}',
        style: const TextStyle(fontSize: 20),
      );
    } else {
      return Text(
        '${widget.room.users[1].firstName} ${widget.room.users[1].lastName}',
        style: const TextStyle(fontSize: 20),
      );
    }
  }
}
*/