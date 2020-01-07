

import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:pangkas_app/model/History.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/screens/history_detail.dart';
import 'package:pangkas_app/services/ApiService.dart';

class HistoryTab extends StatefulWidget {
  final Karyawan karyawan;
  HistoryTab({Key key,this.karyawan}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HistoryTabState();
  }
}

class HistoryTabState extends State<HistoryTab>{
  final GlobalKey<AsyncLoaderState> _asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  final ApiService _apiService = new ApiService();
  int total = 0;
//  List _elements = [
//    {'id': '3173060712940001','name': 'John', 'date': '07/01/2019'},
//    {'id': '3173060712940002','name': 'Abu', 'date': '06/01/2019'},
//    {'id': '3173060712940001','name': 'Febri', 'date': '06/01/2019'},
//    {'id': '3173060712940002','name': 'Iqbal', 'date': '05/01/2019'},
//    {'id': '3173060712940001','name': 'Abu', 'date': '07/01/2019'},
//    {'id': '3173060712940002','name': 'Febri', 'date': '05/01/2019'},
//    {'id': '3173060712940001','name': 'Iqbal', 'date': '07/01/2019'},
//    {'id': '3173060712940003','name': 'John', 'date': '07/01/2019'},
//    {'id': '3173060712940002','name': 'Abu', 'date': '04/01/2019'},
//    {'id': '3173060712940001','name': 'Febri', 'date': '04/01/2019'},
//    {'id': '3173060712940003','name': 'Iqbal', 'date': '02/01/2019'},
//    {'id': '3173060712940003','name': 'Abu', 'date': '01/01/2019'},
//    {'id': '3173060712940001','name': 'Febri', 'date': '01/01/2019'},
//    {'id': '3173060712940003','name': 'Iqbal', 'date': '01/01/2019'},
//  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var _asyncLoader = AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await _apiService.getHistoryByIdnKaryawan(widget.karyawan.identitas),
      renderLoad: () => Center(child: CircularProgressIndicator()),
      renderError: ([error]) => getNoConnectionWidget() ,
      renderSuccess: ({data}) => _buildGroupListHistory(data),
    );
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child :RefreshIndicator(
                onRefresh: _handleRefresh,
                child:_asyncLoader
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
              child: _buildTotalIncome(),
          )
        ],
      )
    );

  }

  Widget _buildGroupListHistory(List<History> allHistory){
    return GroupedListView(
        elements: allHistory,
        groupBy: (elements) => elements.tgl_trx.toString().substring(0,10),
        groupSeparatorBuilder: _buildGroupSeparator,
        sort: false,
        itemBuilder: (context,elements) {
          return Container(
            color: Colors.white,

            child: ListTile(
              leading: Image.asset("assets/images/logo_login.png"),
              title: Text(elements.nama),
              subtitle: Text('Rp'+elements.biaya),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => new HistoryDetailScreen(history: elements))
                );
              },
            ),
          );
        }
    );

  }
   Widget _buildGroupSeparator(dynamic groupByValue) {
     return Container(
       color: Colors.red,
       margin: EdgeInsets.only(top:5.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         mainAxisSize: MainAxisSize.max,
         children: <Widget>[
           Text(widget.karyawan.nama,
               style: TextStyle(
                 fontSize: 20.0,
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
               )),
           Text("$groupByValue",
               style: TextStyle(
                 fontSize: 14.0,
                 color: Colors.white,
               )),
         ],
       ),
       padding: EdgeInsets.all(10.0),
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
            onPressed: () => _asyncLoaderState.currentState.reloadState())
      ],
    );
  }

  Widget _buildTotalIncome(){
    return Card(
      child: ListTile(
        title: Text('Total Per hari ini : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
        subtitle: Text('Rp'+total.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0)),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _asyncLoaderState.currentState.reloadState();
    return null;
  }
}