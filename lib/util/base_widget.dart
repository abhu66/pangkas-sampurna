


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

abstract class BaseWidget {
  void showAlertDialog(BuildContext context, bool params, dynamic obj, String alertTitle,AlertType type);
}
