

import 'package:flutter/cupertino.dart';
import 'package:pangkas_app/screens/home_screen.dart';
import 'package:pangkas_app/screens/login_screen.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/' :          (BuildContext context) => new LoginScreen(),
};