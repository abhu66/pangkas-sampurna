

import 'package:pangkas_app/model/Karyawan.dart';

class KaryawanResponse {
  bool error;
  String message;
  List<Karyawan> data;
  KaryawanResponse({this.error,this.message,this.data});

  factory KaryawanResponse.fromJson(Map<String,dynamic> map){
    var dataKaryawan = map['karyawan'] as List;
    List<Karyawan> karyawans = dataKaryawan.map((i) => Karyawan.fromJson(i)).toList();
    return KaryawanResponse(error: map["error"],message: map["error_message"],data: karyawans);
  }
}