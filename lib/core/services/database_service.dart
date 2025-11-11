import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../app_config.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database get database => _database!;

  static Future<void> initialize() async {
    if (_database != null) return;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConfig.databaseName);

    _database = await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    if (kDebugMode) {
      debugPrint('Local database initialized successfully');
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        age INTEGER,
        gender TEXT,
        weight REAL,
        height REAL,
        water_goal INTEGER DEFAULT ${AppConfig.defaultWaterGoal},
        exercise_goal INTEGER DEFAULT ${AppConfig.defaultExerciseGoal},
        sleep_goal INTEGER DEFAULT ${AppConfig.defaultSleepGoal},
        calorie_goal INTEGER DEFAULT ${AppConfig.defaultCalorieGoal},
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Activities table
    await db.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        time TEXT NOT NULL,
        days TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        achieved_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Sync queue table for offline operations
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    if (kDebugMode) {
      debugPrint('Database tables created successfully');
    }
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic as needed
      if (kDebugMode) {
        debugPrint('Database upgraded from version $oldVersion to $newVersion');
      }
    }
  }

  // Generic CRUD operations
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    return await _database!.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    return await _database!.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  static Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _database!.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _database!.delete(table, where: where, whereArgs: whereArgs);
  }

  // Sync operations
  static Future<void> addToSyncQueue(
    String tableName,
    String recordId,
    String operation,
    Map<String, dynamic> data,
  ) async {
    await insert('sync_queue', {
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'data': data.toString(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    return await query('sync_queue', orderBy: 'created_at ASC');
  }

  static Future<void> removeSyncItem(int id) async {
    await delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearSyncQueue() async {
    await delete('sync_queue');
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await _database!.delete('users');
    await _database!.delete('activities');
    await _database!.delete('reminders');
    await _database!.delete('achievements');
    await _database!.delete('sync_queue');
  }

  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
