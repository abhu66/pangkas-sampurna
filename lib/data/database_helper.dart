
import 'package:pangkas_app/model/Karyawan.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
   static Database _db;

   Future<Database> get db async{
     if(_db != null)
       return _db;
       _db = await initDb();
       return _db;
   }

   DatabaseHelper.internal();

   initDb() async {
      io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path,"main.db");
      var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
      return theDb;
   }

   void _onCreate(Database db, int version) async {
     // When creating the db, create the table
     await db.execute("CREATE TABLE Karyawan(id INTEGER AUTO_INCREMENT PRIMARY KEY, identitas TEXT, nama TEXT, email TEXT, password TEXT,hp TEXT, token TEXT)");
     print("Created tables");
   }

   Future<int> saveKaryawan(Karyawan karyawan) async{
     var dbClient = await db;
     int res = await dbClient.insert("Karyawan", karyawan.toMap());
     return res;
   }

   Future<int> deleteKaryawan(Karyawan karyawan) async {
     var dbClient = await db;
     int res = await dbClient.delete("Karyawan");
     return res;
   }

   Future<bool> isLoggedIn() async{
     var dbClient = await db;
     var res  = await dbClient.query("Karyawan");
     return res.length > 0 ? true : false;
   }
}