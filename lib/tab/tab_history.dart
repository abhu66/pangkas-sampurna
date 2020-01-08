

import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:pangkas_app/model/History.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/presenter/history_tab_presenter.dart';
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

class HistoryTabState extends State<HistoryTab> implements HistoryTabContract{
  final GlobalKey<AsyncLoaderState> _asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  final ApiService _apiService = new ApiService();
  HistoryTabPresenter _historyTabPresenter;
  final ScrollController _scrollController = new ScrollController();
  bool isScrollingDown = false;
  bool _showWidgetTotal = true;
  String total = '0';

  List<History> _historyList;

  @override
  void initState(){
    super.initState();
    _historyTabPresenter = new HistoryTabPresenter(this);
    _historyTabPresenter.doGetTotal(widget.karyawan.identitas);
    myScroll();
  }

  @override
  void dispose(){
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showWidgetTotal() {
    setState(() {
      _showWidgetTotal = true;
    });
  }

  void hideWidgetTotal() {
    setState(() {
      _showWidgetTotal = false;
    });
  }

  void myScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          hideWidgetTotal();
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showWidgetTotal();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var _asyncLoader = AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await _apiService.getHistoryByIdnKaryawan(widget.karyawan.identitas),
      renderLoad: () => Center(child: CircularProgressIndicator()),
      renderSuccess: ({data}) => _buildGroupListHistory(data),
      renderError: ([error]) => getNoConnectionWidget() ,
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
              child: _showWidgetTotal ? _buildTotalIncome() : null,
          ),
        ],
      )
    );

  }

  Widget _buildGroupListHistory(List<History> allHistory){
    _historyList = allHistory;
    return GroupedListView(
        elements: allHistory,
        groupBy: (elements) => elements.tgl_trx.toString().substring(0,10),
        groupSeparatorBuilder: _buildGroupSeparator,
        sort: false,
        controller: _scrollController,
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
                image: new AssetImage(_historyList == null ? 'assets/images/logo_login.png' : 'assets/images/no-wifi.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _historyList == null ? new Text("Belum ada riwayat  !") : new Text("Terjadi kesalahan !"),
        SizedBox(
          height: 10.0,
        ),
        new FlatButton(
            color: Colors.red,
            child: new Text("Retry", style: TextStyle(color: Colors.white),),
            onPressed: () => _asyncLoaderState.currentState.reloadState()),
      ],
    );
  }

  Widget _buildTotalIncome(){
    return Card(
      color: Colors.red,
        child: Padding(padding: EdgeInsets.all(5.0),
          child: Container(
            height: 50.0,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Total hari ini : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.white)),
                    Text('Rp$total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0,color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
        ),
//      child: ListTile(
//        title: Text('Total hari ini : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.white),),
//        subtitle: Text('Rp$total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.white)),
//      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  void onLoadErrorr(String txtError) {
    // TODO: implement onLoadErrorr
    print('Errorr $txtError');
  }

  @override
  void onLoadSuccess(History history) {
    // TODO: implement onLoadSuccess
    setState(() {
      total = history.total;
    });
  }
}