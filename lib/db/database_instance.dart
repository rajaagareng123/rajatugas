import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:running_tracker/model/lari_model.dart';
import 'package:running_tracker/model/lari_detail_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class DatabaseInstance {
  final String _databaseName = 'running_tracker.db';
  final int _databaseVersion = 4;

  // Tabel lari
  final String lariTableName = 'lari';
  final String idLari = 'id';
  final String mulai = 'mulai';
  final String selesai = 'selesai';

  // Tabel detail lari
  final String lariDetailTableName = 'lari_detail';
  final String idLariDetail = 'id';
  final String lariId = 'lari_id';
  final String waktu = 'waktu';
  final String latitude = 'latitude';
  final String longitude = 'longitude';

  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabse();
    return _database!;
  }

  Future<Database> _initDatabse() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${lariTableName}(
      $idLari INTEGER PRIMARY KEY,
      $mulai TEXT,
      $selesai TEXT)''');

    await db.execute('''
      CREATE TABLE ${lariDetailTableName}(
      $idLariDetail INTEGER PRIMARY KEY AUTOINCREMENT,
      $lariId INTEGER,
      $waktu TEXT,
      $latitude REAL,
      $longitude REAL)''');
  }

  Future<List<LariModel>> getAllLari() async {
    final db = await database();
    final data = await db.query(lariTableName, orderBy: "$idLari DESC");
    return data.map((e) => LariModel.fromJson(e)).toList();
  }

  Future<List<MapLatLng>> getDetailLari(int lariIdParam) async {
    final db = await database();
    final data = await db.query(
      lariDetailTableName,
      where: "$lariId = ?",
      whereArgs: [lariIdParam],
    );

    final result = data.map((e) => LariDetailModel.fromJson(e)).toList();
    return result.map((e) => MapLatLng(e.latitude, e.longitude)).toList();
  }

  Future<int> insertLari(Map<String, dynamic> row) async {
    final db = await database();
    return await db.insert(lariTableName, row);
  }

  Future<int> insertDetailLari(Map<String, dynamic> row) async {
    final db = await database();
    return await db.insert(lariDetailTableName, row);
  }

  Future<int> updateLari(int lariIdParam, Map<String, dynamic> row) async {
    final db = await database();
    return await db.update(
      lariTableName,
      row,
      where: '$idLari = ?',
      whereArgs: [lariIdParam],
    );
  }

  //Tambahkan di file database_instance
  Future<int> hapus(int lariId) async {
    final db = await database();
    return db.delete(lariTableName, where: '$idLari = ?', whereArgs: [lariId]);
  }
}
