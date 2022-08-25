import 'package:flutter/material.dart';

class MultiSelect<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final List<T> alreadySelectedItems;
  final Function identifyObject;
  const MultiSelect({Key? key, required this.title, required this.items, required this.alreadySelectedItems, required this.identifyObject}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  // this variable holds the selected items
  final List<T> _selectedItems = [];
  String searchText = '';
  
// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(T itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  int counter = 0;
  Future initItems() async {
    await Future(() => {
      setState((() => counter = 0)),
      for (var item in widget.alreadySelectedItems) {
        if(!_selectedItems.any((element) => widget.identifyObject(element) ==  widget.identifyObject(item))) {
          setState(() {
            _selectedItems.add(item);
          })
        }
        // if(widget.items.contains(item)) {
        //   Utils.showSnackBar(item.keyword);
        // }
      },
    });    
  }

  @override void initState() {
    for (var item in widget.alreadySelectedItems) {
      if(!_selectedItems.any((element) =>  widget.identifyObject(element) == widget.identifyObject(item))) {
        setState(() {
          _selectedItems.add(widget.items.firstWhere((element) => widget.identifyObject(element) == widget.identifyObject(item)));
        });
      }
    }
    super.initState();
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title,
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 18)
              ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(              
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Search', enabledBorder: InputBorder.none),
              onChanged: (changedText) => {
                setState(() {
                  searchText = changedText.toLowerCase();
                })
              }
            ),
            ListBody(
              children: widget.items.where((element) => widget.identifyObject(element).toLowerCase().contains(searchText))
                  .map((item) => CheckboxListTile(
                        value: _selectedItems.contains(item),
                        // selected: widget.alreadySelectedItems.contains(item),
                        title: Text(widget.identifyObject(item)),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) => _itemChange(item, isChecked!),
                      ))
                  .toList(),
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
}