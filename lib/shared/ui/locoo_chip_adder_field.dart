import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';

class LocooChipAdderField extends StatelessWidget {
  const LocooChipAdderField(
      {Key? key,
      required this.tags,
      required this.removeTag,
      required this.showTagDialog,
      required this.addTag})
      : super(key: key);

  final List<String> tags;
  final Function(String tag) removeTag;
  final Function(BuildContext context) showTagDialog;
  final Function(String tag) addTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      // round corners and Theme.of(context)
      // .colorScheme
      // .onSurface
      // .withOpacity(0.05),
      //width full
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),

      child: Padding(
        padding: // left 8 right 8 bottom 8 top 0
            const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          //start
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tags.isNotEmpty)
                  SizedBox(
                    height: 8,
                  ),
                Padding(
                  padding: const //top 8
                      EdgeInsets.only(top: 0),
                  child: Wrap(
                    //vertaicla padding
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Chip(
                        deleteIcon: Icon(
                          Icons.close,
                          size: 16,
                        ),
                        backgroundColor: Colors.white,
                        labelStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                        label: Text('#sdsdsd'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //show sizedbox height 10 when more then 1 tag is in the list
            SizedBox(height: 8),

            ButtonTextField(onPressAdd: addTag),
          ],
        ),
      ),
    );
  }
}

class ButtonTextField extends StatefulWidget {
  const ButtonTextField({super.key, required this.onPressAdd});

  final Function(String tag) onPressAdd;

  @override
  State<ButtonTextField> createState() => _ButtonTextFieldState();
}

class _ButtonTextFieldState extends State<ButtonTextField> {
  bool isButton = true;
  TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isButton
        ? ElevatedButton(
            // onPressed: () => showTagDialog(context),
            onPressed: () {
              //show text field
              setState(() {
                isButton = false;
                tagController.clear();
                print(isButton);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                  size: 18,
                ),
                SizedBox(width: 5),
                Text(
                  'Tag hinzufügen',
                  style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme
                            ?.onPrimary,
                        letterSpacing: -0.07,
                      ),
                ),
              ],
            ),
          )
        : Row(
            children: [
              Expanded(
                child: TextField(
                  // no border 1 padding
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                  controller: tagController,
                  onEditingComplete: () {
                    //show button
                    setState(() {
                      widget.onPressAdd(tagController.text);
                      tagController.clear();
                      isButton = true;
                      print(isButton);
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                // onPressed: () => showTagDialog(context),
                onPressed: () {
                  //show text field
                  setState(() {
                    widget.onPressAdd(tagController.text);
                    tagController.clear();
                    isButton = true;
                    print(isButton);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color:
                          Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Add',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.onPrimary,
                            letterSpacing: -0.07,
                          ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
