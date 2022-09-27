import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class LocooCircleAvatar extends StatelessWidget {
  final String? imageUrl;
  final double? radius;
  const LocooCircleAvatar({super.key, this.imageUrl, this.radius = 55});

  @override
  Widget build(BuildContext context) {
    return //when no imageUrl ist provided then show a contaitner els ecircelavatar
        imageUrl == null
            ? Container(
                height: radius! * 2,
                width: radius! * 2,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FlutterRemix.user_fill,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  size: radius! / 0.9,
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: radius,
                backgroundImage: NetworkImage(imageUrl!),
              );
  }
}
