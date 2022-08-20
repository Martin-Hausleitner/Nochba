import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String font = "SanFrancisco";
    final double size = 20.0;
    final double height = 45.0;

    // return a contianer with a title, a sizedbox, a widped Clip
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          //align left
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'User Info',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            // create a text with weigh t900
            SizedBox(
              height: 18,
            ),
            Wrap(
                // space between chips
                spacing: 10,
                // list of chips
                children: const [
                  Chip(
                    label: Text('Working'),
                    avatar: Icon(
                      Icons.work,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.amberAccent,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  Chip(
                    label: Text('Music'),
                    avatar: Icon(Icons.headphones),
                    backgroundColor: Colors.lightBlueAccent,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  Chip(
                    label: Text('Gaming'),
                    avatar: Icon(
                      Icons.gamepad,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  Chip(
                    label: Text('Cooking & Eating'),
                    avatar: Icon(
                      Icons.restaurant,
                      color: Colors.pink,
                    ),
                    backgroundColor: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  )
                ]),
          ],
        ),
      ),
    );
  }
}
