import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';


class EditAvatar extends StatelessWidget {
  final Uint8List? image;
  final Function(BuildContext context) onTap;

  const EditAvatar({
    Key? key,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            image != null
                ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 55,
                    backgroundImage: MemoryImage(image!),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 55,
                  ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                child: const Icon(
                  FlutterRemix.pencil_line,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
