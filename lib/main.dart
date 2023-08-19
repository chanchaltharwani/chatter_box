import 'package:chatter_box/screens/auth/login_screen.dart';
import 'package:chatter_box/screens/home_screen.dart';
import 'package:chatter_box/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//global object for accessing screen size
late Size mq;
Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value) async =>  await Firebase.initializeApp());
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter Box',
      theme: ThemeData(
     appBarTheme: AppBarTheme(

       centerTitle: true,
       elevation: 1,
         iconTheme: IconThemeData(color: Colors.black),
         titleTextStyle: TextStyle(
             color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),

       backgroundColor: Colors.white,


     )
      ),
      home: const SplashScreen(),

    );
  }
}


