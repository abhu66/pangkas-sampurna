
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pangkas_app/auth.dart';
import 'package:pangkas_app/data/database_helper.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/presenter/login_presenter.dart';
import 'package:pangkas_app/screens/home_screen.dart';
import 'package:pangkas_app/util/base_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> implements BaseWidget,LoginScreenContract,AuthStateListener{


  bool _isLoading     = false;
  final formKey       = new GlobalKey<FormState>();
  final scaffoldKey   = new GlobalKey<ScaffoldState>();
  BuildContext _ctx;
  String _username,_password;
  LoginScreenPresenter _presenter;
  Karyawan dataKaryawan;

  LoginScreenState(){
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if(form.validate()){
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text){
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "Login",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Username must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Nomor Identitas"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Kata Sandi"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );


    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          image: new DecorationImage(
              image: new AssetImage("assets/images/logo_login.png"),),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void onAuthStateChanged(AuthState state) async{
    if(state == AuthState.LOGGED_IN) {
      var db = new DatabaseHelper();
      dataKaryawan = await db.getKaryawan();
      Navigator.of(_ctx).pushReplacement(
          new MaterialPageRoute(settings: const RouteSettings(name: '/home'),
              builder: (_ctx) => new HomeScreen(karyawan: dataKaryawan,)
          )
      );
    }
  }

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
//    _showSnackBar(errorTxt);
    showAlertDialog(context, true, errorTxt,"Login Gagal",AlertType.error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(Karyawan karyawan) async {
    // TODO: implement onLoginSuccess
//    _showSnackBar(karyawan.toString());
    setState(() => _isLoading = false );
    var db = new DatabaseHelper();
    await db.saveKaryawan(karyawan);
    dataKaryawan = await db.getKaryawan();
    showAlertDialog(context, true, "Selamat datang "+karyawan.nama.toUpperCase(),"Login Berhasil",AlertType.success);
  }

  @override
  void showAlertDialog(BuildContext context, bool params, dynamic obj,String alertTitle,AlertType type) {
    // TODO: implement showAlertDialog
    Alert(
      context: context,
      type: type,
      title: "$alertTitle",
      desc:  "$obj",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            if(type == AlertType.success){
              var authStateProvider = new AuthStateProvider();
              authStateProvider.notify(AuthState.LOGGED_IN);
            }
          },
          width: 120,
        )
      ],
    ).show();
  }
}