

import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:pangkas_app/model/History.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/model/Task.dart';
import 'package:pangkas_app/presenter/main_screen_presenter.dart';
import 'package:pangkas_app/services/ApiService.dart';
import 'package:pangkas_app/util/base_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TaskTab extends StatefulWidget{

  final Karyawan karyawan;
  TaskTab({Key key, this.karyawan}) : super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TaskTabState();
  }
}

class TaskTabState extends State<TaskTab> implements MainScreenContact ,BaseWidget{

  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  final ApiService _apiService = new ApiService();
  final bool visible = true;
  MainScreenPresenter _mainScreenPresenter;
  final myController = TextEditingController();
  final formKey       = new GlobalKey<FormState>();
  bool _isLoading = true;
  final nama = TextEditingController();
  final deskripsi =  TextEditingController();
  final biaya = TextEditingController();

  TaskTabState(){
    _mainScreenPresenter = new MainScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {

    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await _apiService.getAllTask(),
      renderLoad: () => Center(child: CircularProgressIndicator(),),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => getListView(data),
    );

    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
          child:_asyncLoader
        ),

      floatingActionButton: widget.karyawan.role == 'admin' ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
            _showAddTaskDialog(context);
        },
      ) : null,
    );
  }

  Widget getListView(List<Task> allTask){
    return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: allTask.length,
          itemBuilder: (context,index) {
            Task task = allTask[index];
            return Card(
              child: Padding(padding: EdgeInsets.all(5.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(task.nama,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                          ),
                          Spacer(),
                          Text("Rp"+task.biaya,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),)
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          RaisedButton(
                            child: Text("Submit",
                              style: TextStyle(color: Colors.white,fontSize: 18.0),),
                            color: Colors.orange[400],
                            onPressed: (){
                                  _showConfirmDialog(context, task);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
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

  Future<Null> _handleRefresh() async {
      asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  void onLoadError(String errorTxt) {
    // TODO: implement onLoadError
    showAlertDialog(asyncLoaderState.currentContext, true, errorTxt,"Simpan Gagal",AlertType.error);
  }

  @override
  void onLoadSuccess(dynamic str) {
    showAlertDialog(asyncLoaderState.currentContext, true, str.toString(),"Simpan Berhasil",AlertType.success);
  }

  void _showConfirmDialog(BuildContext context,Task task){
    Alert(
      context: context,
      title: task.nama,
      content: Column(
        children: <Widget>[
          TextField(
            controller: myController,
            decoration: InputDecoration(
              labelText: 'Keterangan',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: (){
            Navigator.of(context).pop(false);
            _mainScreenPresenter.doSubmitTask(widget.karyawan.identitas, task.nama, task.biaya,myController.text);
         },
          child: Text(
            "Kirim",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
  }
  void _showAddTaskDialog(BuildContext context){
    Alert(
        context: context,
        title: 'Tambah Task',
        style: alertStyle,
        content: Column(
          children: <Widget>[
            TextField(
              controller: nama,
              decoration: InputDecoration(
                labelText: 'Nama Task',
              ),
            ),
            TextField(
              controller: biaya,
              decoration: InputDecoration(
                labelText: 'Nama Biaya',
              ),
            ),
            TextField(
              controller: deskripsi,
              decoration: InputDecoration(
                labelText: 'Keterangan',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: (){
              _mainScreenPresenter.doCreateTask(nama.text, deskripsi.text, biaya.text);
            },
            child: Text(
              "Simpan",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: (){
              dispose();
              //_mainScreenPresenter.doSubmitTask(widget.karyawan.identitas, task.nama, task.biaya,myController.text);
            },
            child: Text(
              "Batal",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  void showAlertDialog(BuildContext context, bool params, obj, String alertTitle, AlertType type) {
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

            setState(() {
              _handleRefresh();
              Navigator.of(context).pop(false);
            });
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