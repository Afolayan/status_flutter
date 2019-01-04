import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/todo.dart';

class DbHelper {

  static final DbHelper _dbHelper  = DbHelper._internal();

  String tableTodo = "todo";
  String columnId = "id";
  String columnTitle = "title";
  String columnDescription = "description";
  String columnPriority = "priority";
  String columnDate = "date";

  DbHelper._internal();

  static Database _db;

  factory DbHelper(){
    return _dbHelper;
  }

  Future<Database> get db async {
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path +"todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int version) async{
    var sql = "CREATE TABLE $tableTodo ($columnId INTEGER PRIMARY KEY, "
        "$columnTitle TEXT, $columnDescription TEXT, $columnPriority INTEGER, $columnDate TEXT)";
    await db.execute(sql);
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tableTodo, todo.toMap());
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    String sql = "SELECT COUNT(*) FROM $tableTodo";
    List<Map<String, dynamic>> list = await db.rawQuery(sql);
    var result = Sqflite.firstIntValue(list);
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    String sql = "SELECT * FROM $tableTodo ORDER BY $columnPriority ASC";
    var result = await db.rawQuery(sql);
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.update(tableTodo, todo.toMap(), where: "$columnId = ?", whereArgs: [todo.id] );
    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("DELETE FROM $tableTodo WHERE $columnId = $id");
    return result;
  }

  insertRandomTodos(){
    Todo todo;
    String date = new DateFormat.yMd().format(DateTime.now());
    for(int i = 1; i <= 10; i++){
      int _priority = i%3 + 1;
      todo = Todo("Buy $i melon", _priority, date, "Make sure you buy it as described");
      insertTodo(todo);
    }
  }
}
