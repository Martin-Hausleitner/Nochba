import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nochba/logic/register/get_location_data.dart';
import 'package:nochba/pages/auth/sign_up_controller.dart';
import 'package:nochba/pages/auth/register/widgets/back_outlined_button.dart';
import 'package:nochba/pages/auth/register/widgets/next_elevated_button.dart';
import 'package:nochba/pages/inset_post/new_post/widgets/progress_line.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';

import '../../../../logic/register/check_if_safe_device.dart';
import '../../../inset_post/new_post/widgets/circle_step.dart';

class SignUpStep4View extends StatelessWidget {
  const SignUpStep4View({super.key, required this.controller});

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
                CircleStep(3, '3', () {}),
                const ProgressLine(
                  isFinished: true,
                ),
                CircleStep(1, '4', () {}),
              ],
            ),
            const SizedBox(height: 28),
            //tile small Wähle deien Kategorie
            Text(
              'Wähle deine Authoezierungs Methode aus',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            //tile small Schritt 1 von 3
            const SizedBox(height: 2),
            Text(
              'Schritt 4 von 4',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 18,
                  // fontWeight: FontWeight.w600,
                  // color: Theme.of(context).secondaryHeaderColor,
                  ),
            ),
            const SizedBox(height: 28),
            //TestLocation(),
            //TestSafeDevice(),
            //InviteCodeInput(),

            ChooserRadio(changeOption: controller.setVerificationOption),

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
                () async {
              controller.nextPage(context: context);
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
  const TestLocation({super.key});

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
  const TestSafeDevice({super.key});

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
  const ChooserRadio({super.key, required this.changeOption});

  final Function(SingingCharacter? sc) changeOption;

  @override
  State<ChooserRadio> createState() => _ChooserRadioState();
}

class _ChooserRadioState extends State<ChooserRadio> {
  SingingCharacter? _character = SingingCharacter.location;

  @override
  void initState() {
    widget.changeOption(_character);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _character = SingingCharacter.location;
            });
            widget.changeOption(_character);
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
                    const SizedBox(width: 10),
                    const Expanded(
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
                    widget.changeOption(_character);
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _character = SingingCharacter.qrcode;
            });
            widget.changeOption(_character);
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
                    const SizedBox(width: 10),
                    const Expanded(
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
                    widget.changeOption(_character);
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
