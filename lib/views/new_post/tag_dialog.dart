import 'package:flutter/material.dart';


class TagDialog extends StatefulWidget {
  const TagDialog({Key? key}) : super(key: key);

  @override
  State<TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<TagDialog> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Write a tag',
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 18)
              ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(    
              controller: textController,          
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Tag'),
            ),
          ],
        )
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, '#${textController.text.trim().replaceAll('#', '')}');
  }
}