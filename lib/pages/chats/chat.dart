import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
// import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nochba/pages/chats/chat_controller.dart';
import 'package:nochba/shared/ui/locoo_circle_avatar.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:nochba/logic/flutter_chat_types-3.4.5/flutter_chat_types.dart'
    as types;
import 'package:nochba/logic/models/user.dart' as models;
import 'package:nochba/logic/flutter_firebase_chat_core-1.6.3/flutter_firebase_chat_core.dart'
    as chat;
import 'package:nochba/logic/flutter_chat_ui-1.6.4/flutter_chat_ui.dart' as ui;
import 'package:nochba/views/public_profile/public_profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../shared/ui/cards/action_card.dart';
import '../../shared/views/bottom_sheet_title_close_view.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key, required this.room}) : super(key: key);
  final types.Room room;

  @override
  Widget build(BuildContext context) {
    //String fullname = "${room.name}";

    final controller = Get.find<ChatController>();
    return Scaffold(
      // backgroundColor: Colors.red,
      // Color(0xffF9F8FD),

      // ignore: unnecessary_new
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          toolbarHeight: 70,
          shadowColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: GestureDetector(
            onTap: () {
              Get.to(PublicProfileView(userId: room.users[0].id));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // CircleAvatar(
                //   radius: 22,
                //   backgroundColor: Colors.white,
                //   child: Padding(
                //     padding: const EdgeInsets.all(1), // Border radius
                //     child: ClipOval(child: displayProfileImage()),
                //   ),
                // ),
                LocooCircleAvatar(
                  imageUrl: room.imageUrl,
                  radius: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  //align left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${room.name}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,

                              // fontWeight: FontWeight.w600,
                            ),
                      ),

                      /*room.name == fullname
                          ? Text(
                              '${room.users[0].firstName} ${room.users[0].lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
          
                                    // fontWeight: FontWeight.w600,
                                  ),
                            )
                          : Text(
                              '${room.users[1].firstName} ${room.users[1].lastName}'),*/
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      //center
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          // show this svg:
                          child: Icon(
                            FlutterRemix.map_pin_line,
                            size: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          room.suburb ?? '',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SvgPicture.asset(
                          'assets/icons/housing_distance.svg',
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.55),
                          height: 12,
                          // semanticsLabel: 'A red up arrow',
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        FutureBuilder<String>(
                          future: controller.getDistanceToUser(room.users),
                          builder: (context, snapshot) {
                            String distance = '';
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              distance = '';
                            } else if (snapshot.hasData) {
                              distance = snapshot.data!;
                            } else {
                              distance = '---';
                            }

                            return Text(
                              distance,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          leading: IconButton(
            splashRadius: 0.001,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: StreamBuilder<types.Room>(
          initialData: room,
          stream: chat.FirebaseChatCore.instance.room(room.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<List<types.Message>>(
                  initialData: const [],
                  stream:
                      chat.FirebaseChatCore.instance.messages(snapshot.data!),
                  builder: (context, snapshot) => Obx(
                        () => ui.Chat(
                          isAttachmentUploading:
                              controller.isAttachmentUploading,
                          messages: snapshot.data ?? [],
                          onAttachmentPressed: () =>
                              _handleAtachmentPressed(context),
                          onMessageTap: _handleMessageTap,
                          onPreviewDataFetched: _handlePreviewDataFetched,
                          onSendPressed: _handleSendPressed,
                          user: models.User(
                            id: chat.FirebaseChatCore.instance.firebaseUser
                                    ?.uid ??
                                '',
                          ),
                        ),
                      ));
            } else {
              return Container();
            }
          }),
    );
  }

  void _handleAtachmentPressed(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: BottomSheetTitleCloseView(
          title: AppLocalizations.of(context)!.addAttachment,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ActionCard(
                    title: AppLocalizations.of(context)!.selectPhoto,
                    icon: FlutterRemix.image_add_line,
                    //open EditProfileView() widget
                    onTap: () async {
                      Navigator.pop(context);
                      _handleImageSelection(context);
                    },
                  ),
                  // const SizedBox(
                  //   height: 2,
                  // ),
                  ActionCard(
                    title: AppLocalizations.of(context)!.takeAPhoto,
                    icon: FlutterRemix.camera_line,
                    //open EditProfileView() widget
                    onTap: () async {
                      Navigator.pop(context);
                      _handleTakePhoto(context);
                    },
                  ),
                ],
              ),
            ),
            // TextButton(
            //   onPressed: () async {
            //     Navigator.pop(context);
            //     _handleImageSelection(context);

            //     // var result = await ImagePicker().pickImage(
            //     //   imageQuality: 70,
            //     //   maxWidth: 1440,
            //     //   source: ImageSource.gallery,
            //     // );

            //     // var imageData = await result!.readAsBytes();

            //     // ignore: use_build_context_synchronously
            //     //var editedImage = await Navigator.push(
            //     //context,
            //     //MaterialPageRoute(
            //     //builder: (context) => ImageEditorExample(),
            //     //),
            //     //);

            //     // // replace with edited image
            //     // if (editedImage != null) {
            //     //   // Convert edited image to xfile
            //     //   result = XFile.fromData(editedImage);
            //     // }

            //     // if (result != null) {
            //     //   _setAttachmentUploading(true);
            //     //   // save edited image to local storage
            //     //   //final file = await File('storage/emulated/0/${DateTime.now().millisecondsSinceEpoch}.jpg').copy(
            //     //   //    'storage/emulated/0/${DateTime.now().millisecondsSinceEpoch}.jpg');
            //     //   // convert xfile to file

            //     //   final file = File(result.path);
            //     //   final size = file.lengthSync();
            //     //   final bytes = await result.readAsBytes();
            //     //   final image = await decodeImageFromList(bytes);
            //     //   final name = result.name;

            //     //   try {
            //     //     final reference = FirebaseStorage.instance.ref(name);
            //     //     await reference.putFile(file);
            //     //     final uri = await reference.getDownloadURL();

            //     //     final message = types.PartialImage(
            //     //       height: image.height.toDouble(),
            //     //       name: name,
            //     //       size: size,
            //     //       uri: uri,
            //     //       width: image.width.toDouble(),
            //     //     );

            //     //     chat.FirebaseChatCore.instance.sendMessage(
            //     //       message,
            //     //       room.id,
            //     //     );
            //     //     _setAttachmentUploading(false);
            //     //   } finally {
            //     //     _setAttachmentUploading(false);
            //     //   }
            //     // }
            //   },
            //   child: const Align(
            //     heightFactor: 2.5,
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       'Select Photo',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            //     ),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //     _handleFileSelection();
            //   },
            //   child: const Align(
            //     heightFactor: 2.5,
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       'Select File',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            //     ),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: const Align(
            //     heightFactor: 2.5,
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       'Cancel',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.any,
    // );

    // if (result != null && result.files.single.path != null) {
    //   _setAttachmentUploading(true);
    //   final name = result.files.single.name;
    //   final filePath = result.files.single.path!;
    //   final file = File(filePath);

    //   try {
    //     final reference = FirebaseStorage.instance.ref(name);
    //     await reference.putFile(file);
    //     final uri = await reference.getDownloadURL();

    //     final message = types.PartialFile(
    //       mimeType: lookupMimeType(filePath),
    //       name: name,
    //       size: result.files.single.size,
    //       uri: uri,
    //     );

    //     chat.FirebaseChatCore.instance.sendMessage(message, room.id);
    //     _setAttachmentUploading(false);
    //   } finally {
    //     _setAttachmentUploading(false);
    //   }
    // }
  }

  void _handleTakePhoto(BuildContext context) async {
    var result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.camera,
    );

    final image = await result!.readAsBytes();
    if (image == null) {
      Get.snackbar("null", "null");
    }
    //final editedImage = await Navigator.push(
    //  context,
    //  MaterialPageRoute(
    //    builder: (context) => const ImageEditorExample(),
    //  ),
    //);

    //final result = editedImage;

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        String userId = room.users[0].id;
        final reference = FirebaseStorage.instance.ref('$userId/$name');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        chat.FirebaseChatCore.instance.sendMessage(message, room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection(BuildContext context) async {
    var result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    final image = await result!.readAsBytes();
    if (image == null) {
      Get.snackbar("null", "null");
    }
    //final editedImage = await Navigator.push(
    //  context,
    //  MaterialPageRoute(
    //    builder: (context) => const ImageEditorExample(),
    //  ),
    //);

    //final result = editedImage;

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        String userId = room.users[0].id;
        final reference = FirebaseStorage.instance.ref('$userId/$name');
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
    String fullname = "${room.users[0].firstName} ${room.users[0].lastName}";
    if (room.name == fullname) {
      return Image.network('${room.users[0].imageUrl}');
    } else {
      return Image.network('${room.users[1].imageUrl}');
    }
  }

  // Text displayProfileName() {
  //   if (room.name == fullname) {
  //     return Text(
  //       '${room.users[0].firstName} ${room.users[0].lastName}',
  //       style: Theme.of(context).textTheme.T,
  //     );
  //   } else {
  //     return Text(
  //       '${room.users[1].firstName} ${room.users[1].lastName}',
  //       style: const TextStyle(fontSize: 20),
  //     );
  //   }
  // }
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
