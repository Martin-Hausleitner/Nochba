import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:nochba/shared/ui/buttons/locoo_text_button.dart';
import 'package:nochba/shared/ui/cards/action_card.dart';
import 'package:nochba/shared/views/app_bar_big_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

//create a class calles InviteNeighborView which have AppBarBigView

//create a invationcode controller with getx
class InviteNeighborController extends GetxController {
  //create a verificationCode variable with getx
  var verificationCode = ''.obs;
  //create a timestamp variable to store the last button press time
  var lastPressTime = 0.obs;

  //get current uid
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  //now create a var lastCodeGenerated which take the "lastCodeGenerated" string anf addd the uid
  String get lastCodeGenerated => 'lastCodeGenerated$uid';

  Future<void> resetLastPressTime() async {
    //get the shared preferences object
    final prefs = await SharedPreferences.getInstance();
    //set the lastPressTime to 0
    lastPressTime.value = 0;
    //save the lastPressTime using shared_preferences
    await prefs.setInt('lastPressTime', 0);
  }

  //create a function to generate a verification code
  Future<void> generateVerificationCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int lastPressTime = prefs.getInt('lastPressTime') ?? 0;

      //get the current time
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final diff = currentTime - lastPressTime;

      if (diff >= 86400000) {
        final HttpsCallable callable = FirebaseFunctions.instanceFor(
          region: 'europe-west1',
        ).httpsCallable(
          'generateVerificationCode',
        );
        final HttpsCallableResult result = await callable();
        print(result.data);
        verificationCode.value = result.data;
        this.lastPressTime.value = currentTime;
        await prefs.setInt('lastPressTime', currentTime);

        final savedCode = prefs.getString(lastCodeGenerated) ?? '';
        if (savedCode != verificationCode.value) {
          await prefs.setString(lastCodeGenerated, verificationCode.value);
        }
      } else {
        final remainingTime = 86400000 - diff;
        final remainingTimeObject = DateTime.fromMillisecondsSinceEpoch(
          remainingTime,
          isUtc: true,
        );
        final hours = remainingTimeObject.hour;
        final minutes = remainingTimeObject.minute;
        final seconds = remainingTimeObject.second;
        Get.snackbar(
          'Wartezeit',
          'Du kannst in $hours Stunden, $minutes Minuten und $seconds Sekunden einen neuen Code generieren',
        );
      }
    } on FirebaseFunctionsException catch (e) {
      print(e.message);
      Get.snackbar('Error', e.message!);
    }
  }

  @override
  void onInit() async {
    final prefs = await SharedPreferences.getInstance();
    verificationCode.value = prefs.getString(lastCodeGenerated) ?? '';
    if (verificationCode.value.isEmpty) {
      await generateVerificationCode();
    }
    print(verificationCode.value);
    print(lastCodeGenerated);

    super.onInit();
  }
}

class InviteNeighborView extends StatelessWidget {
  const InviteNeighborView({super.key});

  @override
  Widget build(BuildContext context) {
    final InviteNeighborController controller =
        Get.put(InviteNeighborController());

    return AppBarBigView(
      title: 'Nachbar einladen',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onPressed: () => {Get.back()},
      children: [
        Row(
          //center
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                // add background color to the rounded container
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      'Dein Einladungscode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Obx(
                        () => QrImage(
                          data: controller.verificationCode.value,
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Spacer(),
                    Obx(
                      () => GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                              text: controller.verificationCode.value));
                          //show snackbar
                          Get.snackbar('Einladungscode wurde kopiert',
                              controller.verificationCode.value);
                          // copied successfully
                        },
                        child: Row(
                          // center
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.verificationCode.value),
                            // Text(verificationCode),
                            const SizedBox(width: 5),
                            //icon copy
                            Icon(
                              color: Theme.of(context).colorScheme.onSurface,
                              FlutterRemix.file_copy_2_line,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ActionCard(
          title: 'Einladungscode teilen',
          icon: FlutterRemix.share_box_line,
          onTap: () {
            Share.share(
                'Hallo Nachbar, ich möchte dich einladen, Teil unserer aktiven Nachbarschaftsgemeinschaft zu werden. Lade dir einfach die Nochba App im Play Store herunter: PLAY STORE LINK. Verwende bei der Registrierung meinen Einladungscode: 123456789.',
                subject: 'Nochba einladungscode');
          },
        ),
        ActionCard(
          title: 'QR-Code Herunterladen',
          icon: FlutterRemix.download_line,
          onTap: () async {
            final byteData = await QrPainter(
              data: controller.verificationCode.value,
              version: QrVersions.auto,
              gapless: true,
              color: Colors.black,
              emptyColor: Colors.white,
            ).toImageData(300.0);

            final Uint8List pngBytes = byteData!.buffer.asUint8List();

            final directory = await getTemporaryDirectory();
            final file = File('${directory.path}/qr_code.png');
            await file.writeAsBytes(pngBytes);

            List<XFile> file1 = [XFile(file.path)];

            await Share.shareXFiles(
              file1,
              text: 'Hier ist dein Einladungs-QR-Code',
              subject: 'Nochba Einladungs-QR-Code',
            );
          },
        ),
        LocooTextButton(
          label: "Neuen Einladecode generieren",
          onPressed: () async {
            await controller.generateVerificationCode();
          },
          icon: FlutterRemix.refresh_line,
        ),
        GestureDetector(
          onTap: () async {
            await controller.resetLastPressTime();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Wenn du einen neuen Einladungscode generierst, wird der alte ungültig.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}
