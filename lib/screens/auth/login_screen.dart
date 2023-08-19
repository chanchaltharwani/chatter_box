import 'package:chatter_box/main.dart';
import 'package:chatter_box/screens/home_screen.dart';
import 'package:flutter/material.dart';

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
    Future.delayed(Duration(microseconds: 500),(){
      setState(() {
        _isAnimate = true;
      });
    });
  }
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                  },
                  icon: Image.asset("images/google.png",height: mq.height * .03,),
                  label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black,fontSize: 16),
                        children: [
                      TextSpan(text: 'Log In With '),
                      TextSpan(text: 'Google',style: TextStyle(fontWeight: FontWeight.w500)),
                    ]),
                  ))),
        ],
      ),
    );
  }
}
