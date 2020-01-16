
import 'dart:async';
import 'package:pangkas_app/model/History.dart';
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/model/Task.dart';
import 'package:pangkas_app/response/history_response.dart';
import 'package:pangkas_app/response/karyawan_response.dart';
import 'package:pangkas_app/response/task_response.dart';
import 'package:pangkas_app/util/network_util.dart';

class ApiService{
 // final String baseUrl = "http://192.168.33.2/pangkas-sampurna/api/"; //emulator
  //static final String BASE_URL = "http://172.25.139.110:8081/pangkas-sampurna/api/"; //hp fisik
  static final String BASE_URL            = "http://pangkas-sampurna.000webhostapp.com/api/"; //PUBLIC
  static final String LOGIN_URL           = BASE_URL + "karyawan/loginkaryawan";
  static final String TASK_URL            = BASE_URL + "task/getalltask";
  static final String CREATE_TASK_URL     = BASE_URL + "task/add";
  static final String HISTORY_URL         = BASE_URL + "history/gethistory";
  static final String SUBMIT_HISTORY_URL  = BASE_URL + "history/add";
  static final String GET_HISTORY_TOTAL   = BASE_URL + "history/gettotal";
  static final String LIST_EMPLOYEE       = BASE_URL + "karyawan/getemployee";
  static final _API_KEY                   = "ABUKHOERULZAMIAT";
  NetworkUtil  _networkUtil               = new NetworkUtil();

  //get karyawan detail
  Future<Karyawan> login(String username, String password) async{
    return _networkUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      if(res['error']){
        throw Exception(res['error_message']);
      }
      else {
        return new KaryawanResponse.fromJson(res).data[0];
      }
    });
  }

  //get All Task
  Future<List<Task>> getAllTask() async{
    return _networkUtil.post(TASK_URL,body: {
      "token":_API_KEY,
      "id":""
    }).then((dynamic res){
      if(res['error']){
        throw Exception(res['error_message']);
      }
      else {
        return new TaskResponse.fromJson(res).data;
      }
    });
  }

  Future<String> addTask(String nama, String deskripsi, String biaya) async {
    return _networkUtil.post(CREATE_TASK_URL, body: {
      "token":_API_KEY,
      "nama":nama,
      "deskripsi":deskripsi,
      "biaya":biaya
    }).then((dynamic res){
      if(res['error']){
        throw Exception(res['error_message']);
      }
      else {
        return "Berhasil";
      }
    });
  }
  Future<List<History>> getHistoryByIdnKaryawan(String idnKaryawan) async {
    return _networkUtil.post(HISTORY_URL,body: {
      "token":_API_KEY,
      "idn_karyawan":idnKaryawan
    }).then((dynamic res){
      if(res['error']){
        throw Exception(res['error_message']);
      }
      else {
        return new HistoryResponse.fromJson(res).data;
      }
    });
  }

  Future<String> submitHistory(String idn_karyawan, String task, String biaya,String keterangan) async {
      return _networkUtil.post(SUBMIT_HISTORY_URL,body:{
        "token":_API_KEY,
        "idn_karyawan":idn_karyawan,
        "nama":task,
        "biaya":biaya,
        "keterangan":keterangan
      }).then((dynamic res){
        if(res['error']){
          throw Exception(res['error_message']);
        }
        else {
          return "Berhasil";
        }
      });
  }
  Future<History> getTotalIncome(String idn_karyawan) async{
    return _networkUtil.post(GET_HISTORY_TOTAL,body:{
      "token":_API_KEY,
      "idn_karyawan":idn_karyawan
    }).then((dynamic res){
      if(res['error']){
        throw Exception(res['error_message']);
      }
      else {
        return HistoryResponse.fromJson(res).data[0];
      }
    });
  }

  Future<List<Karyawan>> getEmployee(String identitas) async {
    return _networkUtil.post(LIST_EMPLOYEE,body: {
      "token":_API_KEY,
      "identitas":identitas
    }).then((dynamic res){
      if(res['error']){
        throw Exception(res['error_message']);
      }
      else {
        return new KaryawanResponse.fromJson(res).data;
      }
    });
  }
}