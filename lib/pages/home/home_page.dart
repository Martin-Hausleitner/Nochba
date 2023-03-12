import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';
import 'package:nochba/pages/auth/auth_page.dart';
import 'package:nochba/pages/dashboard/dashboard_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shake/shake.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future<void> uploadDataToTrello(String text, var screenshot) async {
      var apiKey = Platform.environment['TRELLO_API_KEY'];
      var token = Platform.environment['TRELLO_TOKEN'];
      var boardId = Platform.environment['TRELLO_BOARD_ID'];
      var listId = Platform.environment['TRELLO_LIST_ID'];

      apiKey = dotenv.env['TRELLO_API_KEY'];
      token = dotenv.env['TRELLO_TOKEN'];
      boardId = dotenv.env['TRELLO_BOARD_ID'];
      listId = dotenv.env['TRELLO_LIST_ID'];

      var packageInfo = await PackageInfo.fromPlatform();
      var appName = packageInfo.appName;
      var packageName = packageInfo.packageName;
      var version = packageInfo.version;
      var buildNumber = packageInfo.buildNumber;
      var cardId;

      var name = "v$version+$buildNumber | $text";

      var url1 = Uri.parse(
          "https://api.trello.com/1/cards?key=$apiKey&token=$token&idList=$listId&name=$name&desc=$text");

      try {
        var response1 = await http.post(url1);
        if (response1.statusCode == 200) {
          var responseJson = json.decode(response1.body);
          cardId = responseJson["id"];
          print("Card ID: $cardId");
        } else {
          throw Exception(
              "Failed to retrieve card ID: ${response1.statusCode}${response1.reasonPhrase}");
        }
      } catch (e) {
        print("Error: $e");
      }

      name = "Screenshot.png";

      var url = Uri.parse(
          "https://api.trello.com/1/cards/$cardId/attachments?key=$apiKey&token=$token&name=$name&setCover=true");

      var request = http.MultipartRequest('POST', url);
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          screenshot,
          filename: name,
          contentType: MediaType('image', 'png'),
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Data successfully uploaded to Trello");
      } else {
        throw Exception(
            "Failed to upload data to Trello${response.statusCode}${response.reasonPhrase}");
      }
    }

    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: //open a alertdialog
          () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Schütteln um Feedback zu senden'),
          content: const Text(
              'Du hast dein Gerät geschüttelt! Deine Verbesserungsideen sind uns wichtig. Schicke uns dein Feedback.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                BetterFeedback.of(context).show(
                  (UserFeedback feedback) async {
                    print(feedback.text);
                    uploadDataToTrello(feedback.text, feedback.screenshot);
                  },
                );
              },
              child: const Text('Senden'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (snapshot.hasData) {
          return const DashboardPage();
        } else {
          return const AuthPage();
          // return Scaffold(
          //   body: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         // mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Column(
          //             children: [
          //               Lottie.asset(
          //                 'assets/lottie/shake.json',
          //                 width: 200,
          //                 height: 200,
          //                 fit: BoxFit.cover,
          //               ),
          //             ],
          //           ),
          //           const SizedBox(height: 20),
          //           Text(
          //             'Early Access',
          //             style:
          //                 Theme.of(context).textTheme.headlineMedium?.copyWith(
          //                       fontSize: 30,
          //                       fontWeight: FontWeight.w800,
          //                       letterSpacing: -0.5,
          //                       // color: Theme.of(context).colorScheme.onSecondaryContainer,
          //                       color: Theme.of(context)
          //                           .colorScheme
          //                           .onSecondaryContainer,
          //                     ),
          //           ),
          //           Text(
          //             'Dies ist eine Early-Access-Version, die Bugs enthalten kann.',
          //             style: TextStyle(fontSize: 18),
          //             // textAlign: TextAlign.center,
          //           ),
          //           const SizedBox(height: 20),
          //           ElevatedButton(
          //             onPressed: () {
          //               Get.to(() => const AuthPage());
          //             },
          //             child: const Text('Login'),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        }
      },
    );
  }
}
