import 'dart:ffi';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../models/Track_model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get Database async {
    _database ??= await _database();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'sound_search.db');
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<Void> _createTables(Database db, int version) async {
    await db.execute('''CREATE TABLE playlist (
                       trackId INTEGER PRIMARY KEY,
trackName TEXT NOT NULL,
artistName TEXT NOT NULL,
collectionName TEXT NOT NULL,
artworkUrl TEXT NOT NULL,
previewUrl TEXT,
genre TEXT NOT NULL,
trackTimeMillis INTEGER NOT NULL,
trackPrice REAL NOT NULL,
isExplicit INTEGER NOT NULL DEFAULT 0,
suggestToRadio INTEGER NOT NULL DEFAULT 0
)
''');
  }
}
