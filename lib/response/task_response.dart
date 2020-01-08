
import 'package:pangkas_app/model/Task.dart';

class TaskResponse{
  bool error;
  String message;
  List<Task> data;


  TaskResponse({this.error,this.message,this.data});

  factory TaskResponse.fromJson(Map<String,dynamic> map){
    var dataTask = map['tasks'] as List;
    List<Task> allTask = dataTask.map((i) => Task.fromJson(i)).toList();
    return TaskResponse(error: map['error'],message: map['error_message'],data: allTask);
  }
}