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
    this.lastPressTime.value = 0;
    //save the lastPressTime using shared_preferences
    await prefs.setInt('lastPressTime', 0);
  }

  //create a function to generate a verification code
  Future<void> generateVerificationCode() async {
    try {
      //get the shared preferences object
      final prefs = await SharedPreferences.getInstance();
      //get the lastPressTime from the shared_preferences
      final int lastPressTime = prefs.getInt('lastPressTime') ?? 0;

      //get the current time
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      //calculate the difference between the current time and the last button press time
      final diff = currentTime - lastPressTime;

      if (diff >= 86400000) {
        //if the difference is greater than or equal to 24 hours, execute the function and update the last press time
        final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'generateVerificationCode',
        );
        final HttpsCallableResult result = await callable();
        verificationCode.value = result.data;
        this.lastPressTime.value = currentTime;
        //save the lastPressTime using shared_preferences
        await prefs.setInt('lastPressTime', currentTime);

        final savedCode = prefs.getString(lastCodeGenerated) ?? '';
        if (savedCode != verificationCode.value) {
          await prefs.setString(lastCodeGenerated, verificationCode.value);
        }
      } else {
        //if the difference is less than 24 hours, display the remaining time in a snackbar
        final remainingTime = 86400000 - diff;
        //convert the to da Time object
        final remainingTimeObject = DateTime.fromMillisecondsSinceEpoch(
          remainingTime,
          isUtc: true,
        );
        //get the hours and minutes from the remaining time
        final hours = remainingTimeObject.hour;
        final minutes = remainingTimeObject.minute;
        final seconds = remainingTimeObject.second;
        //display the remaining time in a snackbar im format 00:00:00 and german
        Get.snackbar(
          'Wartezeit',
          'Du kannst in $hours Stunden, $minutes Minuten und $seconds Sekunden einen neuen Code generieren',
          // snackPosition: SnackPosition.BOTTOM,
          // backgroundColor: Colors.red,
          // colorText: Colors.white,
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
    //
    verificationCode.value = prefs.getString(lastCodeGenerated) ?? '';
    // verificationCode.value is emty run generateVerificationCode
    if (verificationCode.value.isEmpty) {
      await generateVerificationCode();
    }
    //print the current verification code
    print(verificationCode.value);
    print(lastCodeGenerated);

    super.onInit();
  }
}

class InviteNeighborView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final InviteNeighborController controller =
        Get.put(InviteNeighborController());

    return AppBarBigView(
      title: 'Nachbar einladen',
      onPressed: () => {Get.back()},
      // backgroundColor: Theme.of(context).colorScheme.surface,
      // contentPadding: EdgeInsets.zero,
      // return a rounded container with a icon on the left side and a text
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
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Obx(
                        () => QrImage(
                          data: controller.verificationCode.value,
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                      ),
                      // child: QrImage(
                      //   data: verificationCode,
                      //   version: QrVersions.auto,
                      //   size: 150.0,
                      // ),
                    ),
                    SizedBox(height: 20),
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
                            SizedBox(width: 5),
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
        SizedBox(height: 10),
        ActionCard(
          title: 'Einladungscode teilen',
          icon: FlutterRemix.share_box_line,
          onTap: () {
            //"Lieber Nachbar, lass uns gemeinsam unsere Nachbarschaft stärken! Ich lade dich herzlich dazu ein, unserer Gruppe beizutreten. Hier ist der Link zur Installation unserer App im Play Store: PLAY STORE LINK. Dein persönlicher Einladungscode lautet: 123456789.
            Share.share(
                'Hallo Nachbar, ich möchte dich einladen, Teil unserer aktiven Nachbarschaftsgemeinschaft zu werden. Lade dir einfach die Nochba App im Play Store herunter: PLAY STORE LINK. Verwende bei der Registrierung meinen Einladungscode: 123456789.',
                subject: 'Nochba einladungscode');
          },
        ),
        LocooTextButton(
          label: "Neuen Einlade Code generieren",
          // code this async onPressed: () => controller.generateVerificationCode(), without a snackbar
          onPressed: () async {
            await controller.generateVerificationCode();
          },

          icon: FlutterRemix.refresh_line,
        ),
        TextButton(
          onPressed: controller.resetLastPressTime,
          child: Text("Reset lastPressTime"),
        ),
        //padding top left right bottom 10
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Wenn du einen neuen Einladungscode generierst, wird der alte ungültig.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
