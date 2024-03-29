import 'package:flutter/material.dart';

class LocooTextField extends StatefulWidget {
  final double height;
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
  final Widget? suffixIcon;
  final bool readOnly;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool? enableInteractiveSelection;
  final void Function(String)? onChanged;

  const LocooTextField({
    super.key,
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
    this.onFieldSubmitted,
    this.height = 50,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.enableInteractiveSelection,
    this.onChanged,
  });

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
  final FocusNode _focusNode = FocusNode();

  // Color for border
  Color _borderColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Change color for border if focus was changed
    _focusNode.addListener(
      () {
        setState(
          () {
            _borderColor = _focusNode.hasFocus
                ? Theme.of(context).primaryColor
                : Colors.transparent;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //set the hight as TextFormField
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          ),
        ),
        TextFormField(
          // enabled: false,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          controller: widget.controller,
          focusNode: //if focusNode is null use _focusNode
              widget.focusNode ?? _focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText,
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            // fillColor: Colors.red,
            border: InputBorder.none,
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _focusNode.hasFocus
                  ? Theme.of(context).primaryColor
                  : // the same color as current
                  Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer
                      .withOpacity(0.7),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

// shoe the validation error and print it to a text
// Visibility(
//   visible: false,
//   child: Padding(
//     padding:
//         // left 10
//         const EdgeInsets.only(left: 12, top: 3.5),
//     child: Text(
//       widget.controller!.text,
//       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: //error color
//                 Theme.of(context).colorScheme.error,
//           ),
//     ),
//   ),
// ),
