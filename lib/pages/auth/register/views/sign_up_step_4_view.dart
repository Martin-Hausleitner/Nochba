import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nochba/logic/register/get_location_data.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../logic/register/check_if_safe_device.dart';
import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpStep4View extends StatelessWidget {
  const SignUpStep4View(
      {super.key, required this.controller, required this.onPressedBack});

  final SignUpController controller;
  final void Function() onPressedBack;

  @override
  Widget build(BuildContext context) {
    List<int> value = [2];
    List<S2Choice<int>> frameworks = [
      S2Choice<int>(value: 1, title: 'Ionic'),
      S2Choice<int>(value: 2, title: 'Flutter'),
      S2Choice<int>(value: 3, title: 'React Native'),
    ];

    return AppBarBigView(
      tailingIcon: Icons.close_rounded,
      title: 'Registrieren',
      onPressed: onPressedBack,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleStep(3, '1', () {}),
                ProgressLine(
                  isFinished: true,
                ),
                CircleStep(3, '2', () {}),
                ProgressLine(
                  isFinished: true,
                ),
                CircleStep(3, '3', () {}),
                ProgressLine(
                  isFinished: true,
                ),
                CircleStep(1, '4', () {}),
              ],
            ),
            SizedBox(height: 28),
            //tile small Wähle deien Kategorie
            Text(
              'Wähle deine Authoezierungs Methode aus',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            //tile small Schritt 1 von 3
            SizedBox(height: 2),
            Text(
              'Schritt 4 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            SizedBox(height: 28),
            TestLocation(),
            TestSafeDevice(),
            TestMobileScanner(),

            ChooserRadio(),

            SizedBox(height: 20),

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
                () async {
              controller.nextPage();
              //close keyboard
              FocusScope.of(context).unfocus();
              // Get.to(PublishedNewPostView());
              // print getLocationData()
              // Position position = await getLocationData();
              // print(position.latitude);
              // print(position.longitude);
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

class TestLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'Test Location',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        Position position = await getLocationData();
        print(position.latitude);
        print(position.longitude);
      },
    );
  }
}

// // create a button which openes MobileScanner  return Scaffold(
//       appBar: AppBar(title: const Text('Mobile Scanner')),
//       body: MobileScanner(
//           allowDuplicates: false,
//           controller: MobileScannerController(
//             facing: CameraFacing.front, torchEnabled: true),
//           onDetect: (barcode, args) {
//             if (barcode.rawValue == null) {
//               debugPrint('Failed to scan Barcode');
//             } else {
//               final String code = barcode.rawValue!;
//               debugPrint('Barcode found! $code');
//             }
//           }),
//     );

class TestMobileScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'Test Mobile Scanner',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        //open a bottom sheet with the mobile scanner as background on the top of the bottom sheet is a button which closes the bottom sheet and on the bottom of the sheet is are 1 button which when pressed shows a textfield

        //show bottom sheet
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          context: context,
          builder: (context) {
            //return a stack where on the bottom is a mobile scanner and on top is a transparent 40% container with a button which closes the bottom sheet
            return Container(
              height: //80% of the screen height
                  MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  //mobile scanner
                  //show the mobile scanner with top round corners
                  ClipRRect(
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
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.srcOut), // This one will create the magic
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                backgroundBlendMode: BlendMode
                                    .dstOut), // This one will handle background + difference out
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: const EdgeInsets.only(top: 80),
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
                  //add on top a cube with corners like a qr code scanner exactly where cut out is (topCenter)
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        //red border only in the cornders
                      ),
                    ),
                  ),
                  //close button
                  Positioned(
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
                  ),
                  // //container with button
                  // Positioned(
                  //   bottom: 0,
                  //   top: 0,
                  //   child: Container(
                  //     // top round corners 25
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.4),
                  //       // round top 25
                  //       borderRadius: const BorderRadius.vertical(
                  //         top: Radius.circular(25.0),
                  //       ),
                  //     ),

                  //     // height: 100,
                  //     width: MediaQuery.of(context).size.width,
                  //     // child: Center(
                  //     //   child: LocooTextButton(
                  //     //     label: 'Test Mobile Scanner',
                  //     //     icon: Icons.arrow_back_rounded,
                  //     //     onPressed:
                  //     //         () async {}, //create a button which runs the emulated firebase cloud function http://
                  //     //   ),
                  //     // ),
                  //   ),
                  // ),

                  //open a bottom sheet with the mobile scanner as background on the top of the bottom sheet is a button which closes the bottom sheet and on the bottom of the sheet is are 1 button which when pressed shows a textfield

                  //show bottom sheet
                ],
              ),
            );
          },
        );
      },
    );
  }
}

//create a button which runs the emulated firebase cloud function http://127.0.0.1:5001/nochba-dev/us-central1/checkAddress

// class TestCloudFunction extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return LocooTextButton(
//       label: 'Test Cloud Function',
//       icon: Icons.arrow_back_rounded,
//       onPressed: () async {
//         HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
//           'checkAddress',
//           options: HttpsCallableOptions(
//             timeout: const Duration(seconds: 5),
//           ),
//         );
//         try {
//           final HttpsCallableResult result =
//               await callable.call(<String, dynamic>{
//             'address': '0x8d1b9c1c5f0f5f0f5f0f5f0f5f0f5f0f5f0f5f0f',
//           });
//           print(result.data);
//         } catch (e) {
//           print(e);
//         }
//       },
//     );
//   }
// }

class TestSafeDevice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocooTextButton(
      label: 'Test Safe Device',
      icon: Icons.arrow_back_rounded,
      onPressed: () async {
        bool isSafe = await checkIfSafeDevice();
        print('Device is safe: $isSafe');
      },
    );
  }
}

enum SingingCharacter { location, qrcode }

class ChooserRadio extends StatefulWidget {
  const ChooserRadio({super.key});

  @override
  State<ChooserRadio> createState() => _ChooserRadioState();
}

class _ChooserRadioState extends State<ChooserRadio> {
  SingingCharacter? _character = SingingCharacter.location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _character = SingingCharacter.location;
            });
          },
          child: Container(
            height: 90,
            // add background color to the rounded container
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                // a listtile ein a gray round box
                Center(
              child: ListTile(
                title: Row(
                  children: [
                    //Email icon
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                          size: 40,
                          Icons.near_me_outlined,
                          // color: Colors.black.withOpacity(0.2)),
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text('Verifiziere dich mit deinen Standort')),
                  ],
                ),
                trailing: Radio<SingingCharacter>(
                  value: SingingCharacter.location,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _character = SingingCharacter.qrcode;
            });
          },
          child: Container(
            height: 90,
            // add background color to the rounded container
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //center align

                  children: [
                    //Email icon
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                          size: 40,
                          // gr code
                          Icons.qr_code_scanner_outlined,
                          // color: Colors.black.withOpacity(0.2)),
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verfiziere dich mit einem QR Code',
                      ),
                    ),
                  ],
                ),
                trailing: Radio<SingingCharacter>(
                  activeColor: Theme.of(context).primaryColor,
                  value: SingingCharacter.qrcode,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
