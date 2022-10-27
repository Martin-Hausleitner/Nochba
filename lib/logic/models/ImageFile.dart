import 'dart:typed_data';

class ImageFile {
  String name;
  Uint8List? file;

  ImageFile({this.name = ''});

  clear() {
    name = '';
    file = null;
  }
}
