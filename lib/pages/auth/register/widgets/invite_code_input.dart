import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/locoo_text_field.dart';

class InviteCodeInput extends StatelessWidget {
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
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  QRcodeScanner(),

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
                            decoration: BoxDecoration(
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
                              decoration: BoxDecoration(
                                color: Colors.red,
                                //red border only in the cornders
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ExitButton(),
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
                  EnterCodeManualButton(),
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
  const QRcodeScanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
      child: MobileScanner(
        allowDuplicates: false,
        controller: MobileScannerController(
            facing: CameraFacing.front, torchEnabled: true),
        onDetect: (barcode, args) {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            final String code = barcode.rawValue!;
            debugPrint('Barcode found! $code');
          }
        },
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton({
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
          color: Theme.of(context).backgroundColor,
          borderRadius: // round
              BorderRadius.circular(100),
        ),

        child: IconButton(
          splashColor: Colors.transparent,
          splashRadius: 0.00001,
          icon: Icon(
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
  const EnterCodeManualButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: //left 20 right 20 bootm 50
            const EdgeInsets.only(left: 30, right: 30, bottom: 50),
        child: LocooTextButton(
          label: 'Manuell eingeben',
          icon: FlutterRemix.edit_line,
          onPressed: () {
            //show a textfield
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: SafeArea(
                    child: Container(
                      height: 160,
                      child: Column(
                        children: [
                          //textfield
                          Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: LocooTextField(
                              label: 'Einladecode',
                              onFieldSubmitted: (value) {
                                //check if the code is valid
                                //if valid close the bottom sheet
                                //if not valid show a snackbar with the error message
                              },
                            ),
                          ),
                          //button
                          Container(
                            margin: const EdgeInsets.only(
                                top: 15, left: 20, right: 20),
                            child: LocooTextButton(
                              label: 'Einladecode überprüfen',
                              icon: FlutterRemix.check_line,
                              onPressed: () {
                                //check if the code is valid
                                //if valid close the bottom sheet
                                //if not valid show a snackbar with the error message
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
