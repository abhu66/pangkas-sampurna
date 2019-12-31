

import 'package:pangkas_app/model/Karyawan.dart';
import 'package:pangkas_app/util/network_util.dart';

class ApiService{
 // final String baseUrl = "http://192.168.33.2/pangkas-sampurna/api/"; //emulator
  static final String BASE_URL = "http://172.25.139.110:8081/pangkas-sampurna/api/"; //hp fisik
  static final String LOGIN_URL = BASE_URL + "karyawan/loginkaryawan";
  static final String TASK_URL  = BASE_URL + "task";
  static final String HISTORY_URL = BASE_URL + "history";
  static final _API_KEY = "ABUKHOERULZAMIAT";
  NetworkUtil  _networkUtil = new NetworkUtil();




//  Future<List<Task>> getAllTask() async{
//
//    final response = await http.get(baseUrl + "task");
//    if(response.statusCode == 200){
//      taskResponse = TaskResponse.fromJson(json.decode(response.body));
//      List<Task> data = taskResponse.data;
//      return data;
//    }
//    else {
//      return null;
//    }
//  }
//
//  Future<List<History>> getAllHistory() async{
//    final response = await http.get(baseUrl + "history");
//    if(response.statusCode == 200) {
//      historyResponse = HistoryResponse.fromJson(json.decode(response.body));
//      List<History> data = historyResponse.data;
//      return data;
//    }
//    else {
//      return null;
//    }
//  }

  Future<Karyawan> login(String username, String password) {
    return _networkUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["error_message"]);
      return new Karyawan.map(res["karyawan"][0]);
    });
  }
}