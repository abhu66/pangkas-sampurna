
import 'package:flutter/material.dart';
import 'package:pangkas_app/activity/employee_activity.dart';
import 'package:pangkas_app/auth.dart';
import 'package:pangkas_app/data/database_helper.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/presenter/main_screen_presenter.dart';
import 'package:pangkas_app/screens/splash_screen.dart';
import 'package:pangkas_app/tab/tab_history.dart';
import 'package:pangkas_app/tab/tab_task.dart';
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

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin
    implements AuthStateListener{

  BuildContext _ctx;
  TabController _tabController;
  GlobalKey _scaffold = GlobalKey();

  HomeScreenState(){
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    // TODO: implement build
    return new Scaffold(
      key: _scaffold,
      appBar: new AppBar(
        title: Text("Pangkas App"),
        bottom: new TabBar(
            controller: _tabController,
            tabs: <Tab>[
              new Tab(child: Text("Task",style: TextStyle(fontSize: 20.0),),),
              new Tab(child: Text("History",style: TextStyle(fontSize: 20.0)),)
            ]
        ),
      ),
      body:  new TabBarView(
        controller: _tabController,
        children: <Widget>[
          TaskTab(karyawan: widget.karyawan),
          HistoryTab(karyawan: widget.karyawan),
        ],
      ) ,
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
//                        image: DecorationImage(
//                            image: AssetImage("assets/images/logo_login.png"),
//                            fit: BoxFit.cover)
                      ),
                    ),
                    ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.list),
                      ),
                      title: Text('Task'),
                      onTap: (){
                        _tabController.animateTo(0);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.history),
                      ),
                      title: Text('History'),
                      onTap: () {
                        _tabController.animateTo(1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.person),
                      ),
                      title: Text('Employee'),
                      onTap: () {
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (context) => new EmployeeActivity(),
                            )
                        );
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
                            _alertLogout(_scaffold.currentContext);
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
//    if(state == AuthState.LOGGED_OUT){
//      Navigator.of(_ctx).pushReplacement(
//          new MaterialPageRoute(settings: const RouteSettings(name: '/'),
//              builder: (context) => new SplashScreen()
//          )
//      );
//    }
  }

  void _logout(BuildContext context) async {
      var db = new DatabaseHelper();
      await db.deleteKaryawan(widget.karyawan);
      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_OUT);
      Navigator.of(_scaffold.currentContext).pop();
      Navigator.of(_scaffold.currentContext).pushReplacement(
          new MaterialPageRoute(settings: const RouteSettings(name: '/'),
              builder: (context) => new SplashScreen()
          )
      );

  }

  void _alertLogout(BuildContext context){
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Keluar",
      style: alertStyle,
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
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