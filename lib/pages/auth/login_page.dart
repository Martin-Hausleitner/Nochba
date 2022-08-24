import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            FlutterLogo(size: 120),
            SizedBox(height: 20),
            Text('Welcome back\nto the neighbourhood',
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)
            ),
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Email')
            ),

            SizedBox(height: 4),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(Icons.lock_open, size: 32), 
              label: Text('Sign In', style: TextStyle(fontSize: 24)),
              onPressed: signIn, 
            ),
            /*GestureDetector(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20
                ),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ForgotPasswordPage()
              )),
            ),*/
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 20),
                text: 'No Account? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
                    text: 'Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,

                    )
                  )
                ]
              ),
            )
          ]
        )
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch(e) {
      print(e);

      //Utils.showSnackBar(e.message);
    }

    //navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}