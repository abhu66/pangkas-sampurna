

import 'dart:convert';

class History{

  String id;
  String idn_karyawan;
  String nama;
  String biaya;
  String keterangan;
  String tgl_trx;
  String total;

  History({this.id,this.idn_karyawan,this.nama,this.biaya,this.keterangan,this.tgl_trx,this.total});

  factory History.fromJson(Map<String, dynamic> map){
    return History(
      id: map['id'],
      idn_karyawan: map['idn_karyawan'],
      nama: map['nama'],
      biaya:map['biaya'],
      keterangan: map['keterangan'],
      tgl_trx: map['tgl_trx'],
      total: map['total'],
    );
  }
  static List<History> historyFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<History>.from(data.map((item) => History.fromJson(item)));
  }
}