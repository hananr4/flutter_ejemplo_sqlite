import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/model/dog.dart';

class DogManager extends ChangeNotifier {
  Database? database;

  //get dogs =>

  init() async {
    final path = join(await getDatabasesPath(), 'doggie_database.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
    );
    notifyListeners();
  }

  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = database!;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserta ${dog.id}');
    notifyListeners();
  }

  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    if (database == null) return <Dog>[];
    final db = database!;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // print('Lista');
    print('${DateTime.now()} Lista');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(
      maps.length,
      (i) {
        return Dog(
          id: maps[i]['id'],
          name: maps[i]['name'],
          age: maps[i]['age'],
        );
      },
    )..sort(
        (x, y) => y.name.compareTo(x.name),
      );
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = database!;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
    print('update ${dog.id}');
    notifyListeners();
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = database!;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    print('delete $id');
    notifyListeners();
  }
}
