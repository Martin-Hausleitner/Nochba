import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

class ImageEditorExample extends StatefulWidget {
  const ImageEditorExample({
    Key? key,
  }) : super(key: key);

  @override
  _ImageEditorExampleState createState() => _ImageEditorExampleState();
}

class _ImageEditorExampleState extends State<ImageEditorExample> {
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    loadAsset(
        "D:\\5CHIF\\DA\\Github-Locoo\\Locoo\\lib\\pages\\chats\\image.png");
  }

  void loadAsset(String name) async {
    var data = await rootBundle.load(name);
    setState(() => imageData = data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageEditor Example"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData != null) Image.memory(imageData!),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Single image editor"),
            onPressed: () async {
              var result = await ImagePicker().pickImage(
                imageQuality: 70,
                maxWidth: 1440,
                source: ImageSource.gallery,
              );

              var imageData = await result!.readAsBytes();

              var editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: imageData,
                  ),
                ),
              );

              // replace with edited image
              if (editedImage != null) {
                imageData = editedImage;
                setState(() {});
              }
            },
          ),
          ElevatedButton(
            child: const Text("Multiple image editor"),
            onPressed: () async {
              var result = await ImagePicker().pickImage(
                imageQuality: 70,
                maxWidth: 1440,
                source: ImageSource.gallery,
              );

              var imageData = await result!.readAsBytes();

              var editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    images: [
                      imageData,
                      imageData,
                    ],
                    allowMultiple: true,
                    allowCamera: true,
                    allowGallery: true,
                  ),
                ),
              );

              // replace with edited image
              if (editedImage != null) {
                imageData = editedImage;
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
