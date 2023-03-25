import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:geocoding/geocoding.dart';

import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpStep3View extends StatelessWidget {
  const SignUpStep3View({super.key, required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return AppBarBigView(
      tailingIcon: Icons.close_rounded,
      title: 'Registrieren',
      onPressed: () async => await controller.quitRegistration(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleStep(3, '1', () {}),
                const ProgressLine(
                  isFinished: true,
                ),
                CircleStep(3, '2', () {}),
                const ProgressLine(
                  isFinished: true,
                ),
                CircleStep(1, '3', () {}),
                const ProgressLine(
                  isFinished: false,
                ),
                CircleStep(2, '4', () {}),
              ],
            ),
            const SizedBox(height: 28),
            //tile small Wähle deien Kategorie
            Text(
              'Gebe deine Adresse ein',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            //tile small Schritt 1 von 3
            const SizedBox(height: 2),
            Text(
              'Schritt 3 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            const SizedBox(height: 28),

            Form(
              key: controller.formKey3,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: LocooTypeAheadFormField(
                          label: 'Straße',
                          controller: controller.streetController,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateAddress,
                          suggestionsCallback: (pattern) async {
                            return await controller
                                .getAddressSuggestions(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            controller.fillAddressFields(suggestion);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: LocooTextField(
                          label: 'Nr.',
                          controller: controller.streetNumberController,
                          validator: controller.validateAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LocooTextField(
                    label: 'Stadt',
                    controller: controller.cityController,
                    validator: controller.validateAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),
                  LocooTextField(
                    label: 'Postleitzahl',
                    controller: controller.zipController,
                    validator: controller.validateAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            BottomNavBar(controller: controller),
          ],
        )
      ],
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BackOutlinedButton(
            controller: controller,
            icon: Icons.chevron_left_rounded,
            label: 'Zurück',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: NextElevatedButton(
            rtl: true,
            onPressed: //controller.addPost() and go to
                () {
              controller.nextPage();
              //close keyboard
              FocusScope.of(context).unfocus();
              // Get.to(PublishedNewPostView());
            },
            controller: controller,
            icon: Icons.chevron_left_outlined,
            label: 'Weiter',
          ),
        ),
      ],
    );
  }
}

class LocooTypeAheadFormField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final SuggestionsCallback<String> suggestionsCallback;
  final ItemBuilder<String> itemBuilder;
  final SuggestionSelectionCallback<String> onSuggestionSelected;

  const LocooTypeAheadFormField({
    Key? key,
    required this.label,
    this.controller,
    this.textInputAction = TextInputAction.go,
    this.validator,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
  }) : super(key: key);

  @override
  _LocooTypeAheadFormFieldState createState() =>
      _LocooTypeAheadFormFieldState();
}

class _LocooTypeAheadFormFieldState extends State<LocooTypeAheadFormField> {
  final FocusNode _focusNode = FocusNode();
  Color _borderColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
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
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          ),
        ),
        TypeAheadFormField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.controller,
            focusNode: _focusNode,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: InputBorder.none,
              labelText: widget.label,
              labelStyle: TextStyle(
                color: _focusNode.hasFocus
                    ? Theme.of(context).primaryColor
                    : Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.7),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          noItemsFoundBuilder: (BuildContext context) => Container(
            height: 50,
            child: Center(
              child: Text(
                'Nichts gefunden!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          suggestionsCallback: widget.suggestionsCallback,
          itemBuilder: widget.itemBuilder,
          onSuggestionSelected: widget.onSuggestionSelected,
          validator: widget.validator,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: // use color: f3f3f3
                Colors.white,
            elevation: 3,
          ),
        ),
      ],
    );
  }
}
