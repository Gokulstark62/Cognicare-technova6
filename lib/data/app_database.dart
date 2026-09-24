import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// Only import the web variant on web builds.
// This prevents "MissingPluginException" on non-web platforms.
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    if (dart.library.io) 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Singleton SQLite database for CogniCare.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const String _dbName = 'cognicare.db';
  static const int _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    // On web, use the WASM-based factory.
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final dbDir = await getDatabasesPath();
    final path = p.join(dbDir, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        purpose TEXT NOT NULL,
        time_hour INTEGER NOT NULL,
        time_minute INTEGER NOT NULL,
        taken INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE water_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER NOT NULL,
        glasses INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE hydration_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE routine (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        time_hour INTEGER NOT NULL,
        time_minute INTEGER NOT NULL,
        icon_code INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        doctor_name TEXT NOT NULL,
        specialty TEXT NOT NULL,
        datetime INTEGER NOT NULL,
        location TEXT NOT NULL,
        notes TEXT NOT NULL,
        icon_code INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE game_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldV, int newV) async {}

  Future<void> reset() async {
    final db = await database;
    await db.delete('medicines');
    await db.delete('water_log');
    await db.delete('routine');
    await db.delete('appointments');
    await db.delete('game_settings');
    await db.delete('hydration_settings');
  }
}
