
import 'package:pangkas_app/model/History.dart';

class HistoryResponse{
  bool error;
  String message;
  List<History> data;


  HistoryResponse({this.error,this.message,this.data});

  factory HistoryResponse.fromJson(Map<String,dynamic> map){
    var dataHistory = map['historys'] as List;
    List<History> allHistory = dataHistory.map((i) => History.fromJson(i)).toList();
    return HistoryResponse(
      error: map['error'],message: map['error_message'],data: allHistory
    );
  }
}