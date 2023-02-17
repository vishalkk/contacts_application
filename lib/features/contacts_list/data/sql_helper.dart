import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE mycontacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        number TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  //call the createTable method
  //create database of given name only once
  //return database object
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'myphonecontact.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

//return id of row in database
  static Future<int> createItem(String name, String? number) async {
    //get database object
    final db = await SQLHelper.db();
    //table data format
    final data = {'name': name, 'number': number};
    final id = await db.insert('mycontacts', data,
        conflictAlgorithm:
            sql.ConflictAlgorithm.replace); //avoid duplicate entry
    return id;
  }

//get the data from database
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('mycontacts', orderBy: "id");
  }

//get single item from db base on id

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('mycontacts', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String name, String? number) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'number': number,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('mycontacts', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("mycontacts", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
