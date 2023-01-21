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
//create a class calles InviteNeighborView which have AppBarBigView

//create a invationcode controller with getx
class InviteNeighborController extends GetxController {
  //create a verificationCode variable with getx
  var verificationCode = ''.obs;
  //create a function to generate a verification code
  Future<void> generateVerificationCode() async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'generateVerificationCode',
      );
      final HttpsCallableResult result = await callable();
      verificationCode.value = result.data;
      // verificationCode = result.data;
    } on FirebaseFunctionsException catch (e) {
      Get.snackbar('Error', e.message!);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

class InviteNeighborView extends StatefulWidget {
  const InviteNeighborView({Key? key}) : super(key: key);

  @override
  State<InviteNeighborView> createState() => _InviteNeighborViewState();
}

class _InviteNeighborViewState extends State<InviteNeighborView> {
  final InviteNeighborController controller =
      Get.put(InviteNeighborController());
  @override
  void initState() {
    super.initState();
    controller.generateVerificationCode();
  }

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
