
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pangkas_app/auth.dart';
import 'package:pangkas_app/data/database_helper.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/presenter/login_presenter.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> implements LoginScreenContract,AuthStateListener{

  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username,_password;
  LoginScreenPresenter _presenter;

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
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "Login App",
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
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
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
          image: new DecorationImage(
              image: new AssetImage("assets/images/logo_login.png"),
              fit: BoxFit.cover),
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

  Widget _iconLogin(){
    return Image.asset("assets/images/logo_login.png",width: 150.0,height: 150.0,);
  }
  Widget _titleDescription(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        Text("Login to App",
          style: TextStyle(color: Colors.white,fontSize: 16.0),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
        ),
        Text("Silahkan login untuk bisa mengakses aplikasi Pangkas Rambut",
          style: TextStyle(color: Colors.white,fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _textField(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
        ),
        TextFormField(
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.5
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3.0
                  )
              ),
              hintText: "Nomor Identitas",
              hintStyle: TextStyle(color: Colors.black26)
          ),
          style: TextStyle(color: Colors.white),
          autofocus: false,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
        ),
        TextFormField(
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3.0
                  )
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.black26)
          ),
          style: TextStyle(color: Colors.white),
          obscureText: true,
          autofocus: false,
        )
      ],
    );
  }
  Widget _buildButton(BuildContext context){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            width: double.infinity,
            child: Text('Masuk',style: TextStyle(color: Colors.orange[400]),textAlign: TextAlign.center),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onTap: (){
            _submit();
          },
        )
      ],
    );
  }

  @override
  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
    _showSnackBar(errorTxt);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(Karyawan karyawan) async {
    // TODO: implement onLoginSuccess
    _showSnackBar(karyawan.toString());
    setState(() => _isLoading = false );
    var db = new DatabaseHelper();
    await db.saveKaryawan(karyawan);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

}