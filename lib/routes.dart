

import 'package:flutter/cupertino.dart';
import 'package:pangkas_app/screens/home_screen.dart';
import 'package:pangkas_app/screens/login_screen.dart';
import 'package:pangkas_app/screens/splash_screen.dart';

final routes = {
  '/' :          (BuildContext context) => new SplashScreen(),
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
};