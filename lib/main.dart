import 'package:locoo/src/features/home/post.dart';
import 'package:locoo/post/category_badge.dart';
import 'package:locoo/shared/rounded_small_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = _textTheme;

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: textTheme,
          scaffoldBackgroundColor: Colors.grey.shade200),

      //change the scaffoldBackgroundColor to Colors.blue[100]

      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Locoo'),
        ),
        body: ScrollNavigation(
          bodyStyle: NavigationBodyStyle(
            background: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          barStyle: NavigationBarStyle(
            background: Colors.white,
            elevation: 0.0,
          ),
          pages: [
            ListView(
              children: [
                Row(
                  children: [
                    // RoundSmallButton with text
                    const RoundedSmallButton(
                      text: 'Button 1',
                    ),
                  ],
                ),
                Post(
                  postTitle: 'Post Title',
                  postImage: 'https://i.pravatar.cc/303',
                  postCategory: Category.mitteilung,
                  postAuthorName: 'John Doe',
                  postPublishDate: '2',
                  postDistance: '1',
                  postDescription: 'Post Dddddescrisssption',
                ),
                SizedBox(height: 3),
                Post(
                  postTitle: 'Post Title',
                  postImage: 'https://i.pravatar.cc/303',
                  postAuthorName: 'John Doe',
                  postPublishDate: '2',
                  postDistance: '1',
                  postDescription:
                      'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
                ),
                SizedBox(height: 3),
                Post(
                  postTitle:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                  postImage: 'https://i.pravatar.cc/303',
                  postAuthorName: 'John Doe',
                  postPublishDate: '2',
                  postCategory: Category.warnung,
                  postDistance: '1',
                  postDescription:
                      'Post https://pub.dev/packages/expandable_text Dddddescrdfffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfffffffffffffffffffffffffffffffffffffffffisf dddddddddddsdffffffffffffsdfffffdddption',
                ),
                ScrollNavigation(
                  bodyStyle: NavigationBodyStyle(
                    background: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  barStyle: NavigationBarStyle(
                    background: Colors.white,
                    elevation: 0.0,
                    position: NavigationPosition.top,
                  ),
                  pages: [
                    Container(color: Colors.blue[100]),
                    Container(color: Colors.green[100]),
                    Container(color: Colors.purple[100]),
                    Container(color: Colors.amber[100]),
                    Container(color: Colors.deepOrange[100])
                  ],
                  items: const [
                    ScrollNavigationItem(icon: Icon(Icons.camera)),
                    ScrollNavigationItem(icon: Icon(Icons.chat)),
                    ScrollNavigationItem(icon: Icon(Icons.favorite)),
                    ScrollNavigationItem(icon: Icon(Icons.notifications)),
                    ScrollNavigationItem(icon: Icon(Icons.home))
                  ],
                ),
              ],
            ),
            Container(color: Colors.green[100]),
            Container(color: Colors.purple[100]),
            Container(color: Colors.amber[100]),
            Container(color: Colors.deepOrange[100])
          ],
          items: const [
            ScrollNavigationItem(icon: Icon(Icons.home_outlined)),
            ScrollNavigationItem(icon: Icon(Icons.notifications_outlined)),
            ScrollNavigationItem(icon: Icon(Icons.add_circle_outlined)),
            ScrollNavigationItem(icon: Icon(Icons.chat_bubble_outline)),
            ScrollNavigationItem(icon: Icon(Icons.perm_identity_outlined))
          ],
        ));
  }
}
