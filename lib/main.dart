
import 'package:flutter/material.dart';
import 'package:pangkas_app/routes.dart';
import 'package:pangkas_app/auth.dart';


void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Login App',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }


}