import 'dart:developer';
import 'dart:io';

import 'package:chatter_box/main.dart';
import 'package:chatter_box/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/api.dart';
import '../../helper/dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  handleGoogleBtnLinked() {
    //for showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        print(user.user);
        log('\nUser:${user.user}');
        log('\nUseradditionalUserInfo:${user.additionalUserInfo}');
        if ((await APIs.userExist())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
         await APIs.createUser().then((value) => {
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()))
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('_signInWithGoogle: $e');
      Dialogs.showSnakebar(context, "Something went wrong (check Internet)");
      return null;
    }
  }

  //sign out
  // _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  //
  // }
  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome To Chatter box",
        ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: Duration(seconds: 5),
              child: Image.asset("images/appicon.png")),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent.shade200,
                      shape: StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    // _signOut();
                    handleGoogleBtnLinked();
                  },
                  icon: Image.asset(
                    "images/google.png",
                    height: mq.height * .03,
                  ),
                  label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(text: 'Log In With '),
                          TextSpan(
                              text: 'Google',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ]),
                  ))),
        ],
      ),
    );
  }
}
