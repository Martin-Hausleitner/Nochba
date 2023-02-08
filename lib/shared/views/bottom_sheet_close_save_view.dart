import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:nochba/shared/ui/buttons/locoo_circular_icon_button.dart';

class BottomSheetCloseSaveView extends StatelessWidget {
  //children
  final List<Widget> children;
  final VoidCallback onSave;

  const BottomSheetCloseSaveView(
      {super.key, required this.children, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: //top 10
                    const EdgeInsets.only(
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
                    const Spacer(),

                    // LocooCircularIconButton(
                    //   iconData: FlutterRemix.check_line,
                    //   fillColor: Theme.of(context).primaryColor,
                    //   iconColor: Colors.white,
                    //   radius: 32,
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                    ElevatedButton.icon(
                      // onPressed triggers onSave and navigation pop
                      onPressed: () {
                        onSave();
                        Navigator.pop(context);
                      },

                      //() => Navigator.pop(context),
                      icon: const Icon(
                        FlutterRemix.check_line,
                      ),
                      label: Text(
                        'Speichern',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.onPrimary,
                              letterSpacing: -0.07,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        // minimumSize: Size.fromHeight(35),
                        // maximumSize: //set size 30
                        // Size.fromHeight(30),
                        shadowColor: Colors.transparent,
                        // primary: Theme.of(context).buttonTheme.colorScheme?.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
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
      ),
    );
  }
}
