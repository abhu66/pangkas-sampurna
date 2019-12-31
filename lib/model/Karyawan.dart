
class Karyawan{
  String id;
  String identitas;
  String nama;
  String email;
  String password;
  String hp;
  String token;

  Karyawan({this.identitas,this.nama,this.email,this.password,this.hp,this.token});

  Karyawan.map(dynamic obj){
    this.identitas = obj["identitas"];
    this.nama = obj["nama"];
    this.email = obj["email"];
    this.password = obj["password"];
    this.hp  = obj["hp"];
    this.token = obj["token"];
  }

  String get _identitas => identitas;
  String get _nama      => nama;
  String get _email     => email;
  String get _password  => password;
  String get _hp        => hp;
  String get _token     => token;


  Map<String, dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map["identitas"] = identitas;
    map["nama"]      = nama;
    map["email"]     = email;
    map["password"]  = password;
    map["hp"]        = hp;
    map["token"]     = token;

    return map;
  }


}