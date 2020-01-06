


class Karyawan{
  String id;
  String identitas;
  String nama;
  String email;
  String password;
  String hp;
  String token;

  Karyawan({this.identitas,this.nama,this.email,this.password,this.hp,this.token});

  factory Karyawan.fromJson(Map<String, dynamic> map){
    return Karyawan(
      identitas : map['identitas'],
      nama      : map['nama'],
      email     : map['email'],
      password  : map['password'],
      hp        : map['hp'],
      token     : map['token'],
    );
  }

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
     map['identitas'] = identitas;
     map['nama']      = nama;
     map['email']     = email;
     map['password']  = password;
     map['hp']        = hp;
     map['token']     = token;

    return map;
  }
  Karyawan.fromMap(Map<String, dynamic> map) {
    identitas = map['identitas'];
    nama      = map['nama'];
    email     = map['email'];
    password  = map['password'];
    hp        = map['hp'];
    token     = map['token'];
  }
}