

import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pangkas_app/model/Task.dart';
import 'package:pangkas_app/services/ApiService.dart';

class TaskTab extends StatelessWidget {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  final ApiService _apiService = new ApiService();
  final bool visible = true;
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

}