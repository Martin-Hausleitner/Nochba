import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';

class LocooTextField extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final bool autofocus;
  final void Function(String)? onFieldSubmitted;

  const LocooTextField(
      {super.key,
      required this.label,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      // assign emty controller
      this.controller,
      this.textInputAction = TextInputAction.go,
      this.obscureText = false,
      this.autovalidateMode,
      this.validator,
      this.autofocus = false,
      this.onFieldSubmitted});

  // const LocooTextField({
  //   super.key,
  //   required this.label,
  //   this.keyboardType = TextInputType.text,
  //   this.maxLines = 1,
  // });

  @override
  _LocooTextFieldState createState() => _LocooTextFieldState();
}

class _LocooTextFieldState extends State<LocooTextField> {
  // Use it to change color for border when textFiled in focus
  FocusNode _focusNode = FocusNode();

  // Color for border
  Color _borderColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Change color for border if focus was changed
    _focusNode.addListener(() {
      setState(() {
        _borderColor = _focusNode.hasFocus
            ? Theme.of(context).primaryColor
            : Colors.transparent;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,

          autofocus: widget.autofocus,
          // onFieldSubmitted: (value) => Get.back(),
          onFieldSubmitted: widget.onFieldSubmitted,

          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          // keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding:

                // top 8 bottom 8 left 8 right 8
                EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            fillColor: Colors.red,
            // counterText: //current word count
            //     '',

            // labelStyle: ,

            border: InputBorder.none,
            labelText: widget.label,

            floatingLabelBehavior: FloatingLabelBehavior.always,
            // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            // prefixIcon: Padding(
            //   padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            //   child:
            //       Text("₦", style: TextStyle(fontSize: 16, color: Colors.grey)),
            // ),
          ),
        ),
      ),
    );
  }
}

class EditAvatar extends StatelessWidget {
  const EditAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                splashRadius: 16,
                splashColor: Theme.of(context).primaryColor.withOpacity(.4),
                icon: Icon(
                  FlutterRemix.pencil_line,
                  color: Colors.white,
                  size: 17,
                ),
                // onpress open snack bar
                onPressed: () {
                  Get.snackbar(
                    "Edift",
                    "Edit your profile",
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
