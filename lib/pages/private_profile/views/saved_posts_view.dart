import 'package:flutter/material.dart';
import 'package:locoo/shared/views/app_bar_big_view.dart';

class SavedPostsView extends StatelessWidget {
  const SavedPostsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(title: 'Gespeicherten Posts', children: [
      Text('lol'),
    ]);
  }
}
