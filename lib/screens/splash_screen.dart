import 'package:chatter_box/main.dart';
import 'package:chatter_box/screens/auth/login_screen.dart';
import 'package:chatter_box/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 9),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));

    });
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,

              child: Image.asset("images/appicon.png")),
          Positioned(
              bottom: mq.height * .15,

              width: mq.width,

              child:Text("MADE IN WITH INDIA ❤️",style: TextStyle(fontSize: 19,color: Colors.black,letterSpacing: .5),textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
}
