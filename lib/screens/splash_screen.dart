

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pangkas_app/data/database_helper.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/screens/home_screen.dart';
import 'package:pangkas_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget{

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  AnimationController _animationController;


  @override
  void initState(){

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    startSplashScreen();
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    var db = new DatabaseHelper();
    Karyawan k = await db.getKaryawan();
    String path = k == null ? "/login" : "/home";
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
              settings: RouteSettings(name: '$path'),
              builder: (context) => k == null ? new LoginScreen() : new HomeScreen(karyawan: k,)
          )
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
          child:  Image.asset(
            "assets/images/logo_login.png",
            width: 200.0,
            height: 100.0,
          ),
        ),

      ),
    );
  }
}