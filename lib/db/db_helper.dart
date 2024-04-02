import 'package:simple_calendar/models/event.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "events";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "events.db";
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind STRING, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Event? event) async {
    print("insert function called");
    return await _db?.insert(_tableName, event!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Event event) async {
    return _db!.delete(_tableName, where: 'id=?', whereArgs: [event.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE events
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
