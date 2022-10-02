import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';

class BottomSheetTitleCloseView extends StatelessWidget {
  //children
  final List<Widget> children;
  final String title;

  const BottomSheetTitleCloseView(
      {super.key, required this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
                  //space between
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
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
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                //align left
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
