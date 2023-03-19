import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class AlertDialogDelete extends StatelessWidget {
  const AlertDialogDelete(
      {Key? key, required this.label, required this.onDelete})
      : super(key: key);

  final String label;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        //add round corner 20
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          //align center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add a red icon flutterremix error-warning-line
            const Icon(
              FlutterRemix.error_warning_line,
              // color: Theme.of(context).colorScheme.error,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '$label löschen',
              //add fontwiehgt w500
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete $label?',
          //style the text gray
          style: const TextStyle(color: Color.fromARGB(133, 36, 36, 36)),
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Abbrechen'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Abbrechen'),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context, 'OK');
                  },
                  //style the button red
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Löschen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
