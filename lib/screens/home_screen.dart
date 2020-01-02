

import 'package:flutter/material.dart';
import 'package:pangkas_app/auth.dart';
import 'package:pangkas_app/data/database_helper.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/presenter/login_presenter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget {
  final Karyawan karyawan;
  HomeScreen({Key key,this.karyawan}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen> implements AuthStateListener{
  BuildContext _ctx;

  HomeScreenState(){
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Center(
        child: new Text("Welcome home! "+widget.karyawan.email),
      ),
      drawer: new Drawer(
        child : Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Text(widget.karyawan.nama + " | " + widget.karyawan.hp),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.list),
                    ),
                    title: Text('Task'),
                    onTap: (){

                    },
                  ),
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.history),
                    ),
                    title: Text('History'),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.exit_to_app),
                        ),
                        title: Text('Logout'),
                        onTap: () {
                            Navigator.pop(context);
                          _alertLogout();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  @override
  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_OUT)
      Navigator.of(_ctx).pushReplacementNamed("/");
  }

  void _logout(BuildContext context) async {
      var db = new DatabaseHelper();
      await db.deleteKaryawan(widget.karyawan);
      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_OUT);
  }

  void _alertLogout(){
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Keluar",
      desc: "Anda yakin ingin keluar dari aplikasi ?",
      buttons: [
        DialogButton(
          child: Text(
            "Ya",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            _logout(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Tidak",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

}