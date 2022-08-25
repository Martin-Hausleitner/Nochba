import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locoo/shared/action_card.dart';

// Text(
//                 'Settings',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               SizedBox(height: 20),

// create a settings Page which have a list of rounded containers with a text and a icon on the left side with scaffold

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navTitleTextStyle:
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                      // fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      // letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
            // navLargeTitleTextStyle: GoogleFonts.inter(
            //   fontSize: 30,
            //   fontWeight: FontWeight.w800,
            //   letterSpacing: -0.5,
            //   color: Theme.of(context).colorScheme.onSecondaryContainer,
            //   // color: Colors.black,
            // ),
            navLargeTitleTextStyle:
                Theme.of(context).textTheme.headlineMedium?.copyWith(
                      // fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
          ),
          barBackgroundColor: Theme.of(context).backgroundColor),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          // A list of sliver widgets.
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              // padding: EdgeInsetsDirectional.only(
              //   start: 7,
              //   end: 23,
              // ),

              // leading: Icon(CupertinoIcons.person_2),
              // This title is visible in both collapsed and expanded states.
              // When the "middle" parameter is omitted, the widget provided
              // in the "largeTitle" parameter is used instead in the collapsed state.
              largeTitle: Text(
                'Profil Bearbeiten',
              ),
              leading: Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 0.1,
                  icon: Icon(
                    FlutterRemix.arrow_left_line,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
              // padding left 10
              padding: EdgeInsetsDirectional.only(
                start: 12,
                end: 10,
              ),

              border: //make the border transparent
                  const Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            // add a Silverlist with SettingsCard
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 30,
                  ),
                  EditAvatar(),
                  SizedBox(
                    height: 30,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: TextField(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: TextField(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: TextField(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: TextField(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: TextField(),
                  ),

                  // Create TextFormField with a focusNode which triggers a DecoratedBox border to change to red border
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextField extends StatefulWidget {
  TextField({Key? key}) : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  // Use it to change color for border when textFiled in focus
  FocusNode _focusNode = FocusNode();

  // Color for border
  Color _borderColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Change color for border if focus was changed
    _focusNode.addListener(() {
      setState(() {
        _borderColor = _focusNode.hasFocus
            ? Theme.of(context).primaryColor
            : Colors.transparent;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        ),
        child: TextFormField(
          focusNode: _focusNode,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding:
                // top 8 bottom 8 left 8 right 8
                EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            fillColor: Colors.red,
            // labelStyle: ,

            border: InputBorder.none,
            labelText: "Test",
            // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            // prefixIcon: Padding(
            //   padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            //   child:
            //       Text("₦", style: TextStyle(fontSize: 16, color: Colors.grey)),
            // ),
          ),
        ),
      ),
    );
  }
}

class EditAvatar extends StatelessWidget {
  const EditAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1518791841217-8f162f1e1131?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60",
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                splashRadius: 16,
                splashColor: Theme.of(context).primaryColor.withOpacity(.4),
                icon: Icon(
                  FlutterRemix.pencil_line,
                  color: Colors.white,
                  size: 17,
                ),
                // onpress open snack bar
                onPressed: () {
                  Get.snackbar(
                    "Edift",
                    "Edit your profile",
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
