import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();

  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("contacts.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";

    await db.execute('''
    CREATE TABLE ${ModelFields.contactsTable} (
    ${ModelFields.id} $idType,
    ${ModelFields.name} $textType
    )
    ''');

    debugPrint("-------DB----------CREATED---------");
  }


  static Future<ModelSql> insertContact(
      ModelSql modelSql) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        ModelFields.contactsTable, modelSql.toJson());
    return modelSql.copyWith(id: id);
  }

  static Future<List<ModelSql>> getAllContacts() async {
    List<ModelSql> allToDos = [];
    final db = await getInstance.database;
    allToDos = (await db.query(ModelFields.contactsTable))
        .map((e) => ModelSql.fromJson(e))
        .toList();

    return allToDos;
  }

}


class ModelFields {
  static const String id = "_id";
  static const String name = "name";

  static const String contactsTable = "searchTexts";
}

class ModelSql {
  int? id;
  final String name;

  ModelSql({
    this.id,
    required this.name,
  });

  ModelSql copyWith({
    String? name,
    int? id,
  }) {
    return ModelSql(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  factory ModelSql.fromJson(Map<String, dynamic> json) {
    return ModelSql(
      name: json[ModelFields.name] ?? "",
      id: json[ModelFields.id] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ModelFields.name: name,
    };
  }

  @override
  String toString() {
    return '''
      name: $name
      id: $id, 
    ''';
  }
}