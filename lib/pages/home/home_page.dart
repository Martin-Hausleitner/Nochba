import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:locoo/pages/auth/auth_page.dart';
import 'package:locoo/pages/dashboard/dashboard_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        else if(snapshot.hasData) {
          return DashboardPage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}