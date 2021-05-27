import 'dart:async';

import 'package:sqlite/database/database.dart';
import 'package:sqlite/model/dog.dart';

class DogDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new  records
  Future<int> create(Dog dog) async {
    final db = await dbProvider.database;
    var result = db.insert(
      dogsTABLE,
      dog.toDatabaseJson(),
    );
    return result;
  }

  //Get All  items
  //Searches if query string was passed
  Future<List<Dog>> getAll({List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>>? result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(dogsTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(dogsTABLE, columns: columns);
    }

    List<Dog> dogs = result != null && result.isNotEmpty
        ? result.map((item) => Dog.fromDatabaseJson(item)).toList()
        : [];
    print("${DateTime.now()} get All $query $columns");
    return dogs;
  }

  //Update  record
  Future<int> update(Dog dog) async {
    final db = await dbProvider.database;

    var result = await db.update(
      dogsTABLE,
      dog.toDatabaseJson(),
      where: "id = ?",
      whereArgs: [dog.id],
    );

    return result;
  }

  //Delete  records
  Future<int> delete(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      dogsTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAll() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      dogsTABLE,
    );

    return result;
  }
}
