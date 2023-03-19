import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';

class InviteCodeInput extends StatelessWidget {
  const InviteCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'Test Mobile Scanner',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        //open a bottom sheet with the mobile scanner as background on the top of the bottom sheet is a button which closes the bottom sheet and on the bottom of the sheet is are 1 button which when pressed shows a textfield

        //show bottom sheet
        showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          context: context,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  QRcodeScanner(
                    checkQRCode: ((qrCode) async => true),
                  ),

                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.8),
                          BlendMode.srcOut), // This one will create the magic
                      child: Stack(
                        // fit: StackFit.expand,
                        children: [
                          Container(
                            height: 4000,
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                backgroundBlendMode: BlendMode
                                    .dstOut), // This one will handle background + difference out
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 200,
                              width: 200,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                //red border only in the cornders
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const CloseButton(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      child: Text(
                        'Scanne deinen QR Einladecode',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ),
                  //possiton on the bottom of the sheet a locoo button which opens a textfield
                  EnterCodeManualButton(
                    checkQRCode: (qrCode) async {
                      return false;
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class QRcodeScanner extends StatelessWidget {
  const QRcodeScanner({Key? key, required this.checkQRCode}) : super(key: key);

  final Future<bool> Function(String qrCode) checkQRCode;

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
      child: MobileScanner(
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              debugPrint('Barcode found! $code');

              try {
                final result = await checkQRCode(code);
                Navigator.pop(context, result);
              } on Exception {
                Navigator.pop(context, false);
              }
            }
          }
        },
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        height: 40,
        width: 40,
        //round and color colorscheme background
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: // round
              BorderRadius.circular(100),
        ),

        child: IconButton(
          splashColor: Colors.transparent,
          splashRadius: 0.00001,
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class EnterCodeManualButton extends StatelessWidget {
  const EnterCodeManualButton({Key? key, required this.checkQRCode})
      : super(key: key);
  final Future<bool> Function(String qrCode) checkQRCode;

  @override
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
        child: LocooTextButton(
          label: 'Manuell eingeben',
          icon: FlutterRemix.edit_line,
          onPressed: () {
            TextEditingController controller = TextEditingController();
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              context: context,
              builder: (context) {
                bool isLoading = false;
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isLoading
                                  ? Padding(
                                      padding: // top 20 bottom 20
                                          const EdgeInsets.only(
                                              top: 25, bottom: 25),
                                      child: CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        LocooTextField(
                                          label: 'Einladecode',
                                          controller: controller,
                                        ),
                                        SizedBox(height: 10),
                                        LocooTextButton(
                                          label: 'Code bestätigen',
                                          icon: FlutterRemix.key_line,
                                          onPressed: () async {
                                            String value = controller.text;
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              final result =
                                                  await checkQRCode(value);
                                              Navigator.pop(context, result);
                                              Navigator.pop(context, result);
                                            } on Exception {
                                              Navigator.pop(context, false);
                                            } finally {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
