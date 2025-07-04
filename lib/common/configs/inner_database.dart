import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InnerDatabase {
  static Database? _db;

  static Future<void> initialize() async {
    if (_db != null) {
      return; // 이미 초기화됐다면 이 과정 생략
    }

    // DB 열기
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'alarmi.db');
    var exist = await databaseExists(path);

    try {
      if (!exist) {
        await Directory(dirname(path)).create(recursive: true);

        ByteData data = await rootBundle.load(
          join('assets', 'dbs', 'alarmi.db'),
        );
        List<int> bytes = data.buffer.asInt8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );

        await File(path).writeAsBytes(bytes, flush: true);
      }

      // DB 열기 (존재하든, 새로 복사했든)
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow; // 초기화 실패 시 예외 다시 던지기
    }
  }

  static Database get instance {
    if (_db == null) {
      throw Exception(
        '데이터베이스가 초기화되지 않았습니다. NotificationController.initAwesomeNotifications()를 먼저 호출해주세요.',
      );
    }
    return _db!;
  }

  static _onCreate(Database db, int version) async {
    await db.execute('''
  	CREATE TABLE alarms (
    	id INTEGER PRIMARY KEY AUTOINCREMENT,
    	type TEXT NOT NULL, 
    	alarmKeys TEXT NOT NULL,
    	weekdays TEXT NOT NULL,
    	bellId TEXT,
    	vibrateId TEXT,
    	isWakeUpMission INTEGER DEFAULT 0 NOT NULL,
    	alarmTime TEXT NOT NULL,
    	register TEXT NOT NULL,
    	isDisabled INTEGER DEFAULT 0 NOT NULL,
      createdAt DATETIME,
      updatedAt DATETIME)
    ''');
    if (kDebugMode) {
      print('alarms table created.');
    }
  }

  static _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      print('Database upgraded from version $oldVersion to $newVersion');
    }
  }

  static _onDowngrade(Database db, int oldVersion, int newVersion) async {
    if (kDebugMode) {
      print('Database downgraded from version $oldVersion to $newVersion');
    }
  }

  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      if (kDebugMode) {
        print('Database closed');
      }
    }
  }
}
