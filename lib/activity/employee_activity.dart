



import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/services/ApiService.dart';

class EmployeeActivity extends StatefulWidget{

  EmployeeActivity({Key key}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EmployeeState();
  }

}

class _EmployeeState extends State<EmployeeActivity> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  final ApiService _apiService = new ApiService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await _apiService.getEmployee(""),
      renderLoad: () => Center(child: CircularProgressIndicator(),),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => getListView(data),
    );

    return SafeArea(
      child: Scaffold(
        appBar:  AppBar(
          title: Text("List Employee"),
        ),
        body: _asyncLoader,
      ),
    );
  }

  Widget getNoConnectionWidget(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60.0,
          child: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/images/no-wifi.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        new Text("Terjadi kesalahan !"),
        SizedBox(
          height: 10.0,
        ),
        new FlatButton(
            color: Colors.red,
            child: new Text("Retry", style: TextStyle(color: Colors.white),),
            onPressed: () => asyncLoaderState.currentState.reloadState())
      ],
    );
  }

  Widget getListView(List<Karyawan> allEmployee){
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: allEmployee.length,
      itemBuilder: (context,index) {
        Karyawan karyawan = allEmployee[index];
        return new Card(
            child: new Column(

              children: <Widget>[
                new ListTile(
                  leading: new Image.asset(
                    "assets/images/man.png",
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),

                  title: new Text(
                    karyawan.nama,
                    style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(karyawan.identitas,
                            style: new TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.normal)),
                        new Text(karyawan.email,
                            style: new TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.normal)),
                      ]),
                  //trailing: ,
                  onTap: () {
                      _settingModalBottomSheet(context,karyawan);
                  },
                  trailing: karyawan.role == "admin" ? IconButton(icon: Icon(Icons.more_vert),
                  onPressed: () {

                  },): null,
                )
              ],
            ));
      },
    );
  }

  void _settingModalBottomSheet(context, Karyawan karyawan){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Image.asset(
                    "assets/images/man.png",
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 80.0,
                  ),

                  title: new Text(
                    karyawan.nama.toUpperCase(),
                    style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(karyawan.identitas,
                            style: new TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.normal)),
                        new Text(karyawan.email,
                            style: new TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.normal)),
                        new Text(karyawan.hp,
                            style: new TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.normal)),
                      ]),
                  //trailing: ,
                  onTap: () {
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Pendapatan hari ini",style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text("    : ",style: new TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text("Rp200.000",style: new TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Pendapatan bulan ini",style: new TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text(" : ",style: new TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold)),
                          Text("Rp200.000",style: new TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}