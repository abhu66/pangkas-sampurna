
import 'dart:convert';

class Task{
  String id;
  String nama;
  String deskripsi;
  String biaya;


  Task({this.id,this.nama,this.deskripsi,this.biaya});

  factory Task.fromJson(Map<String, dynamic> map){
    return Task(
      id: map['id'],
      nama: map['nama'],
      deskripsi: map['deskripsi'],
      biaya: map['biaya'],
    );
  }

  static List<Task> taskFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<Task>.from(data.map((item) => Task.fromJson(item)));
  }
}