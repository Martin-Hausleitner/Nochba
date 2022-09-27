import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';

import 'locoo_circle_avatar.dart';

class EditAvatar extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const EditAvatar({
    Key? key,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            // CircleAvatar(
            //   backgroundColor: Colors.black26,
            //   radius: 55,
            //   backgroundImage: NetworkImage(
            //     "https://ui-avatars.com/api/?name=John+Doe",
            //   ),
            // ),
            //create a circle container with i user icon in the center
            // when image url is emty show container
            LocooCircleAvatar(
              imageUrl: imageUrl,
              radius: 55,
            ),

            SizedBox(
              height: 30.0,
              width: 30.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Icon(
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
