


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pangkas_app/model/History.dart';

class HistoryDetailScreen extends StatefulWidget{
  final History history;
  HistoryDetailScreen({Key key,this.history}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HistoryDetailState();
  }
}

class HistoryDetailState extends State<HistoryDetailScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.history.nama),
      ),
      body: new Card(
        child: Padding(padding: EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("ID",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  subtitle: Text(widget.history.idn_karyawan+"- HST"+widget.history.id,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                ),
                Divider(),
                ListTile(
                  title: Text("Tugas",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  subtitle: Text(widget.history.nama,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                ),
                Divider(),
                ListTile(
                  title: Text("Biaya",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  subtitle: Text('Rp'+widget.history.biaya,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                ),
                Divider(),
                ListTile(
                  title: Text("Tanggal",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  subtitle: Text(widget.history.tgl_trx,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                ),
                Divider(),
                ListTile(
                  title: Text("Keterangan",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  subtitle: Text(widget.history.keterangan,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}