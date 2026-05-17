import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../models/Track_model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'sound_search.db');
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
            CREATE TABLE playlist (
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

  Future<void> insertTrack(TrackModel track) async {
    final db = await database;
    await db.insert(
      'playlist',
      track.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrackModel>> getAllTracks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('playlist');
    return maps.map((map) => TrackModel.fromMap(map)).toList();
  }

  Future<void> deleteTrack(int trackId) async {
    final db = await database;
    await db.delete('playlist', where: 'trackId = ?', whereArgs: [trackId]);
  }

  Future<bool> isTrackSaved(int trackId) async {
    final db = await database;
    final result = await db.query(
      'playlist',
      where: 'trackId = ?',
      whereArgs: [trackId],
      limit: 1,
    );

    return result.isNotEmpty;
  }
}
