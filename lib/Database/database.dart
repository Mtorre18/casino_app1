
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:io';

import 'package:casino_app/Casinos/model.dart';

class CasinoDatabase {
  static final CasinoDatabase _instance = CasinoDatabase._internal();

  factory CasinoDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  CasinoDatabase._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE Casinos(id STRING PRIMARY KEY, 
        name TEXT, photos TEXT, 
        rating TEXT, 
        favored BIT)""");

    print("Database was Created!");
  }

  Future<List<Casino>> getCasinos() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("Casinos");
    return res.map((m) => Casino.fromDb(m)).toList();
  }

  Future<Casino> getCasino(String id) async {
    var dbClient = await db;
    var res = await dbClient.query("Casinos", where: "id = ?", whereArgs: [id]);
    if (res.length == 0) return null;
    return Casino.fromDb(res[0]);
  }

  Future<int> addCasino(Casino casino) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Casinos", casino.toMap());
      print("Casino added $res");
      return res;
    } catch (e) {
      int res = await updateCasino(casino);
      return res;
    }
  }

  Future<int> updateCasino(Casino casino) async {
    var dbClient = await db;
    int res = await dbClient.update("Casinos", casino.toMap(),
        where: "id = ?", whereArgs: [casino.id]);
    print("Casino updated $res");
    return res;
  }

  Future<int> deleteCasino(String id) async {
    var dbClient = await db;
    var res = await dbClient.delete("Casinos", where: "id = ?", whereArgs: [id]);
    print("Casino deleted $res");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}