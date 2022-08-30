// import 'package:flutter/material.dart';
// import 'package:flutter_remix/flutter_remix.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:locoo/shared/round_icon_button.dart';

// import 'border_icon_button.dart';

// class AppBar1 extends StatelessWidget {
//   const AppBar1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: Colors.white,
//       // A ScrollView that creates custom scroll effects using slivers.
//       child: CupertinoTheme(
//         data: CupertinoThemeData(
//           textTheme: CupertinoTextThemeData(
//             navTitleTextStyle: GoogleFonts.inter(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//             navLargeTitleTextStyle: GoogleFonts.inter(
//               fontSize: 30,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.5,
//               color: Colors.black,
//             ),
//           ),
//           barBackgroundColor: Colors.white,
//         ),
//         child: CustomScrollView(
//           // A list of sliver widgets.
//           slivers: <Widget>[
//             CupertinoSliverNavigationBar(
//               leading: Icon(CupertinoIcons.back),
//               padding: EdgeInsetsDirectional.only(
//                 start: 7,
//                 end: 7,
//               ),

//               // leading: Icon(CupertinoIcons.person_2),
//               // This title is visible in both collapsed and expanded states.
//               // When the "middle" parameter is omitted, the widget provided
//               // in the "largeTitle" parameter is used instead in the collapsed state.
//               largeTitle: Row(
//                 children: [
//                   Text(
//                     'Nachrichten',
//                   ),
//                   Icon(
//                     CupertinoIcons.search,
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//               trailing: Icon(FlutterRemix.pencil_line, size: 25),
//               border: //make the border transparent
//                   const Border(bottom: BorderSide(color: Colors.transparent)),
//             ),
//             // This widget fills the remaining space in the viewport.
//             // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
//             SliverFillRemaining(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[Text('Ddd')],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NextPage extends StatelessWidget {
//   const NextPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Brightness brightness = CupertinoTheme.brightnessOf(context);
//     return CupertinoPageScaffold(
//       child: CustomScrollView(
//         slivers: <Widget>[
//           CupertinoSliverNavigationBar(
//             backgroundColor: CupertinoColors.systemYellow,
//             border: Border(
//               bottom: BorderSide(
//                 color: brightness == Brightness.light
//                     ? CupertinoColors.black
//                     : CupertinoColors.white,
//               ),
//             ),
//             // The middle widget is visible in both collapsed and expanded states.
//             middle: const Text('Contacts Group'),
//             // When the "middle" parameter is implemented, the larget title is only visible
//             // when the CupertinoSliverNavigationBar is fully expanded.
//             largeTitle: const Text('Family'),
//           ),
//           SliverFillRemaining(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: const <Widget>[
//                 Text('Drag me up', textAlign: TextAlign.center),
//                 // When the "leading" parameter is omitted on a route that has a previous page,
//                 // the back button is automatically added to the leading position.
//                 Text('Tap on the leading button to navigate back',
//                     textAlign: TextAlign.center),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppBar1 extends StatelessWidget {
//   const AppBar1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             pinned: true,
//             snap: true,
//             floating: true,
//             shadowColor: Colors.transparent,
//             backgroundColor: Colors.white,
//             expandedHeight: 160.0,
//             forceElevated: true,
//             actions: [
//               // IconButton(
//               //   icon: const Icon(FlutterRemix.pencil_line),
//               //   color: Colors.black,
//               //   onPressed: () {
//               //     Get.snackbar('dsfdsf', 'dsfdsf');
//               //   },
//               // ),
//               IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _user == null
//                 ? null
//                 : () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         fullscreenDialog: true,
//                         builder: (context) => const UsersPage(),
//                       ),
//                     );
//                   },
//           ),
//           IconButton(
//           icon: const Icon(Icons.logout),
//           onPressed: _user == null ? null : logout,
//         ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//                 title: Text(
//                   'Nachrichten',
//                   style: GoogleFonts.inter(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -0.5,
//                     color: Color.fromARGB(255, 22, 22, 22),
//                   ),
//                 ),
//                 titlePadding: EdgeInsets.only(left: 15, bottom: 15)),
//           ),
//           // add a SilverLsit
//           SliverFillRemaining(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[Text('Ddd')],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
