
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
  GlobalKey _scaffoldKey = new GlobalKey();
  BuildContext _ctx;
  String _username,_password;
  LoginScreenPresenter _presenter;
  Karyawan dataKaryawan;

  LoginScreenState(){
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return new Scaffold(
      appBar: null,
      key: _scaffoldKey,
      body: new Container(
        padding: EdgeInsets.all(30.0),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  _iconLogin(),
                  _titleLogin(),
                  _formLogin(),
                  _buildButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _iconLogin(){
    return Image.asset("assets/images/logo_login.png",
    width: 150.0,
    height: 150.0,);
  }

  Widget _titleLogin(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        Text("Login",
        style: TextStyle(color: Colors.white,fontSize: 16.0),)
      ],
    );
  }

  Widget _formLogin(){
    return Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new TextFormField(
                onSaved: (val) => _username = val,
                validator: (val) {
                  return val.length < 10
                      ? "ID must have atleast 16 chars"
                      : null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'ID',
                ),
              ),
              new TextFormField(
                onSaved: (val) => _password = val,
                validator: (val) {
                  return val.length < 5
                      ? "Password must have atleast 6 chars"
                      : null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext _ctx){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
        ),
        InkWell(
          onTap: (){
            _loginProcess();
          },
          child: Container(
            width: double.infinity,
            child:
            RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                _loginProcess();
              },
              color: Colors.red,
              textColor: Colors.white,
              child: _isLoading ? _loadingIndicator() : Text("Login".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
            ),
          ),
        )
      ],
    );
  }
  Widget _loadingIndicator() {
    return Container(
        width: 20.0,
        height: 20.0,
        child: (CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
          backgroundColor: Colors.yellow,
          value: 0.2,
        ))
    );
  }
  void _loginProcess(){
    final form = formKey.currentState;
    if(form.validate()){
      setState(() => _isLoading = true);
        form.save();
      _presenter.doLogin(_username, _password);
    }
  }


  @override
  void onAuthStateChanged(AuthState state) async{
    if(state == AuthState.LOGGED_IN) {
      var db = new DatabaseHelper();
      dataKaryawan = await db.getKaryawan();
      Navigator.of(_ctx).pushReplacement(
          new MaterialPageRoute(settings: const RouteSettings(name: '/home'),
              builder: (context) => new HomeScreen(karyawan: dataKaryawan,)
          )
      );
    }
//    else {
//      Navigator.of(context).pushReplacement(
//          new MaterialPageRoute(settings: const RouteSettings(name: '/'),
//              builder: (context) => new SplashScreen()
//          )
//      );
//    }
  }

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
    showAlertDialog(_scaffoldKey.currentContext, true, errorTxt,"Login Gagal",AlertType.error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(Karyawan karyawan) async {
    // TODO: implement onLoginSuccess
    setState(() => _isLoading = false );
    var db = new DatabaseHelper();
    await db.saveKaryawan(karyawan);
    dataKaryawan = await db.getKaryawan();
    //Navigator.of(_ctx).pop();
    showAlertDialog(_scaffoldKey.currentContext, true, "Selamat datang "+karyawan.nama.toUpperCase(), "Login Berhasil", AlertType.success);

  }

  @override
  void showAlertDialog(BuildContext context, bool params, dynamic obj,String alertTitle,AlertType type) {
    // TODO: implement showAlertDialog
    Alert(
      context: context,
      type: type,
      style: alertStyle,
      title: "$alertTitle",
      desc:  "$obj",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if(type == AlertType.success){
              var authStateProvider = new AuthStateProvider();
              authStateProvider.notify(AuthState.LOGGED_IN);
            }
            Navigator.of(_scaffoldKey.currentContext).pop(false);
          },
          width: 120,
        )
      ],
    ).show();
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );
}