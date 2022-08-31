import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:locoo/shared/ui/buttons/locoo_circular_icon_button.dart';

class BottomSheetView extends StatelessWidget {
  //children
  final List<Widget> children;

  const BottomSheetView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: //top 10
                  EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
              ),
              child: Row(
                children: [
                  //iconButton black x -> close sheet
                  LocooCircularIconButton(
                    iconData: FlutterRemix.close_line,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.05),
                    iconColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.9),
                    radius: 35,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),

                  LocooCircularIconButton(
                    iconData: FlutterRemix.check_line,
                    fillColor: Theme.of(context).primaryColor,
                    iconColor: Colors.white,
                    radius: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
