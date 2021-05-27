import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final dogsTABLE = 'dogs';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "doggie_database.db");
    var database = await openDatabase(path,
        version: 2, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute(
      'CREATE TABLE $dogsTABLE('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'adopt INTEGER, '
      'age INTEGER)',
    );
  }
}
